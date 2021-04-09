defmodule CtznClient do
  @moduledoc """
  Documentation for `CtznClient`.
  """

  use GenServer

  alias CtznClient.Socket

  require Logger

  @activity_timeout 300_000
  @request_timeout 5000

  @impl true
  def handle_call({:send, msg}, _, %{socket_pid: pid} = state) do
    state = reset_timeout(state)
    WebSockex.cast(pid, {:send, msg})

    receive do
      {:result, result} ->
        {:reply, result, state}
    after
      @request_timeout ->
        {:reply, :req_timeout, state}
    end
  end

  def handle_info(:timeout, _, _) do
    {:stop, :timeout}
  end

  @impl true
  def init(params) do
    client_id = params[:client_id]
    timeout = if params[:timeout], do: set_timeout()

    {:ok, pid} = Socket.start_link(client_id: client_id, client_pid: self(), host: params[:host])

    state = %{
      client_id: client_id,
      socket_pid: pid,
      timeout: timeout
    }

    {:ok, state}
  end

  def start_link(params) do
    name = process_name(params[:client_id])
    GenServer.start_link(__MODULE__, params, name: name)
  end

  defp process_name(client_id), do: {:via, Registry, {Registry.CtznClient, client_id}}

  defp reset_timeout(%{timeout: nil} = state), do: state

  defp reset_timeout(%{timeout: timeout} = state) do
    Process.cancel_timer(timeout)
    %{state | timeout: set_timeout()}
  end

  defp set_timeout, do: Process.send_after(self(), :timeout, @activity_timeout)
end
