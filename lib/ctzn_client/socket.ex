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
  @initial_state %{rpc_id: 1, name: nil, session: nil}

  def start_link(%Session{session_id: name, user_id: user_id} = session) do
    [_, host] = String.split(user_id, "@")
    state = %{@initial_state | name: name, session: session}

    metadata = [session_id: name, user_id: user_id]
    Logger.info("Ctzn client connecting (SessionId=#{name}, UserId=#{user_id})", metadata)

    host
    |> get_uri()
    |> WebSockex.start_link(__MODULE__, state, name: name)
  end

  def start_link(name) do
    state = %{@initial_state | name: name}

    metadata = [session_id: name, user_id: nil]
    Logger.info("Ctzn client connecting (SessionId=#{name}, UserId=nil)", metadata)

    @default_host
    |> get_uri()
    |> WebSockex.start_link(__MODULE__, state, name: name)
  end

  def handle_cast({:send, {method, params}}, state) do
    metadata = [method: method, params: Jason.encode!(params)]
    Logger.info("Ctzn client running method (Method=#{method})", metadata)

    {id, state} = get_next_id(state)
    frame = build_frame!(id, method, params)

    {:reply, frame, state}
  end

  def handle_disconnect(%{conn: %Conn{} = conn, reason: {:remote, _}}, %{name: name} = state) do
    Logger.debug("Ctzn client reconnecting (SessionId=#{name})", session_id: name)

    with %{session: %Session{session_id: session_id}} <- state,
         do: Accounts.resume_session(self(), session_id)

    {:reconnect, conn, state}
  end

  def handle_disconnect(_, %{name: name} = state) do
    Logger.debug("Ctzn client terminating connection (SessionId=#{name})", session_id: name)
    {:ok, state}
  end

  def handle_frame({:text, msg}, %{name: name} = state) do
    result = parse_frame(msg)
    PubSub.broadcast(__MODULE__, "#{name}", {:result, result})

    metadata = [result: Jason.encode!(result), session_id: name]
    Logger.debug("Ctzn client received frame (SessionId=#{name})", metadata)

    {:ok, update_state(state, result)}
  end

  defp build_frame!(id, method, params) do
    msg =
      Jason.encode!(%{
        id: id,
        jsonrpc: "2.0",
        method: method,
        params: params
      })

    {:text, msg}
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

  defp update_state(state, %{"sessionId" => _} = result) do
    %{state | session: Session.parse(result)}
  end

  defp update_state(state, _), do: state
end
