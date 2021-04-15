defmodule CtznClient.Communities do
  @moduledoc """
  Documentation for `CtznClient.Communities`
  """

  @timeout 30_000

  def create(client, create_info, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"communities.create", [create_info]}}, timeout)
  end

  def join(client, community, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"communities.join", [community]}}, timeout)
  end

  def remote_join(client, opts, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"communities.remoteJoin", [opts]}}, timeout)
  end

  def leave(client, community, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"communities.leave", [community]}}, timeout)
  end

  def remote_leave(client, opts, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"communities.remoteLeave", [opts]}}, timeout)
  end
end
