defmodule CtznClient.Socket do
  @moduledoc """
  Documentation for `CtznClient.Socket`.
  """

  use WebSockex

  alias CtznClient.{Accounts, Session}
  alias Phoenix.PubSub
  alias WebSockex.Conn

  require Logger

  @default_host "ctzn.one"
  @initial_state %{client_id: nil, rpc_id: 1, session: nil, timeout: nil}
  @socket_timeout 300_000

  def process_name(client_id), do: {:via, Registry, {Registry.CtznClient, client_id}}

  def start_link(params) do
    client_id = params[:client_id]
    host = params[:host] || @default_host
    timeout = params[:timeout]
    state = %{@initial_state | client_id: client_id, timeout: timeout}

    metadata = [client_id: client_id]
    Logger.info("Ctzn client connecting (ClientId=#{client_id})", metadata)

    host
    |> get_uri()
    |> WebSockex.start_link(__MODULE__, state, name: process_name(client_id))
  end

  def handle_cast({:send, {method, params}}, state) do
    metadata = [method: method, params: Jason.encode!(params)]
    Logger.info("Ctzn client running method (Method=#{method})", metadata)

    {id, state} = get_next_id(state)
    frame = build_frame!(id, method, params)

    {:reply, frame, reset_timeout(state)}
  end

  def handle_connect(_, %{timeout: true} = state) do
    timeout = Process.send_after(self(), :timeout, @socket_timeout)
    state = %{state | timeout: timeout}
    {:ok, state}
  end

  def handle_disconnect(
        %{conn: %Conn{} = conn, reason: {:remote, _}},
        %{client_id: client_id} = state
      ) do
    Logger.debug("Ctzn client reconnecting (ClientId=#{client_id})", client_id: client_id)

    with %{session: %Session{session_id: session_id}} <- state,
         do: Accounts.resume_session(self(), session_id)

    {:reconnect, conn, state}
  end

  def handle_disconnect(_, %{client_id: client_id} = state) do
    metadata = [client_id: client_id]
    Logger.debug("Ctzn client terminating connection (ClientId=#{client_id})", metadata)

    {:ok, state}
  end

  def handle_frame({:text, msg}, %{client_id: client_id} = state) do
    result = parse_frame(msg)
    PubSub.broadcast(__MODULE__, client_id, {:result, result})

    metadata = [client_id: client_id, msg: msg]
    Logger.debug("Ctzn client received frame (ClientId=#{client_id})", metadata)

    state =
      state
      |> update_state(result)
      |> reset_timeout()

    {:ok, state}
  end

  def handle_info(:timeout, %{client_id: client_id} = state) do
    metadata = [client_id: client_id]
    Logger.debug("Ctzn client timing out due to inactivity (ClientId=#{client_id})", metadata)

    {:close, state}
  end

  def handle_ping(:ping, state) do
    {:reply, :pong, state}
  end

  def handle_pong(:pong, state) do
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

  defp parse_frame(str_msg) do
    with {:ok, msg} <- Jason.decode(str_msg),
         %{"result" => result} <- msg,
         do: result
  end

  defp reset_timeout(%{timeout: nil} = state), do: state

  defp reset_timeout(%{timeout: timeout} = state) do
    Process.cancel_timer(timeout)
    timeout = Process.send_after(self(), :timeout, @socket_timeout)
    %{state | timeout: timeout}
  end

  defp update_state(state, %{"sessionId" => _} = result) do
    %{state | session: Session.parse(result)}
  end

  defp update_state(state, _), do: state
end
