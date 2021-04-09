defmodule CtznClient.Socket do
  @moduledoc """
  Documentation for `CtznClient.Socket`.
  """

  use WebSockex

  alias CtznClient.{Accounts, Session}
  alias WebSockex.Conn

  require Logger

  @default_host "ctzn.one"
  @initial_state %{client_id: nil, client_pid: nil, rpc_id: 1, session: nil}

  def start_link(params) do
    client_id = params[:client_id]
    client_pid = params[:client_pid]
    host = params[:host] || @default_host
    state = %{@initial_state | client_id: client_id, client_pid: client_pid}

    host
    |> get_uri()
    |> WebSockex.start_link(__MODULE__, state)
  end

  def handle_connect(%Conn{}, state) do
    Logger.info("CTZN socket connected #{log_suffix(state)}", log_metadata(state))

    {:ok, state}
  end

  def handle_cast({:send, {method, params}}, %{rpc_id: id} = state) do
    metadata =
      state
      |> log_metadata()
      |> Keyword.merge(method: method, message_id: id, params: Jason.encode!(params))

    suffix = log_suffix(state, ["MessageId=#{id}", "Method=#{method}"])
    Logger.debug("CTZN client running method #{suffix}", metadata)

    {id, state} = get_next_id(state)
    frame = build_frame!(id, method, params)

    {:reply, frame, state}
  end

  def handle_disconnect(%{conn: %Conn{} = conn, reason: {:remote, _}}, state) do
    Logger.info("CTZN client reconnecting #{log_suffix(state)}", log_metadata(state))

    with %{session: %Session{session_id: session_id}} <- state,
         do: Accounts.resume_session(self(), session_id)

    {:reconnect, conn, state}
  end

  def handle_disconnect(_, state) do
    Logger.info("CTZN client disconnecting #{log_suffix(state)}", log_metadata(state))

    {:ok, state}
  end

  def handle_frame({:text, msg}, %{client_pid: pid} = state) do
    %{"result" => result, "id" => id} = parse_frame(msg)
    send(pid, {:result, result})

    metadata = state |> log_metadata() |> Keyword.merge(message: msg, message_id: id)
    suffix = log_suffix(state, ["MessageId=#{id}"])
    Logger.debug("CTZN client received frame #{suffix}", metadata)

    {:ok, update_state(state, result)}
  end

  def handle_ping(:ping, state) do
    Logger.debug("CTZN client received ping #{log_suffix(state)}", log_metadata(state))

    {:reply, :pong, state}
  end

  def handle_pong(:pong, state) do
    Logger.debug("CTZN client received pong #{log_suffix(state)}", log_metadata(state))

    {:ok, state}
  end

  defp build_frame!(id, method, params) do
    msg = %{
      id: id,
      jsonrpc: "2.0",
      method: method,
      params: params
    }

    {:text, Jason.encode!(msg)}
  end

  defp get_next_id(%{rpc_id: id} = state) when is_integer(id) do
    new_state = %{state | rpc_id: id + 1}
    {id, new_state}
  end

  defp get_uri("localhost" <> _ = host), do: "ws://#{host}"
  defp get_uri(host), do: "wss://#{host}"

  defp log_metadata(%{client_id: client_id}), do: [client_id: client_id]

  defp log_suffix(%{client_id: client_id}, base \\ []) do
    suffix = Enum.join(["ClientId=#{client_id}" | base], ", ")
    "(#{suffix})"
  end

  defp parse_frame(str_msg) do
    with {:ok, msg} <- Jason.decode(str_msg),
         %{"id" => _, "jsonrpc" => "2.0", "result" => _} <- msg,
         do: msg
  end

  defp update_state(state, %{"sessionId" => _} = result) do
    %{state | session: Session.parse(result)}
  end

  defp update_state(state, _), do: state
end
