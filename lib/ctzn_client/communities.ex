defmodule CtznClient.Communities do
  @moduledoc """
  Documentation for `CtznClient.Communities`
  """

  def create(client, create_info) do
    GenServer.call(client, {:send, {"communities.create", [create_info]}})
  end

  def join(client, community) do
    GenServer.call(client, {:send, {"communities.join", [community]}})
  end

  def remote_join(client, opts) do
    GenServer.call(client, {:send, {"communities.remoteJoin", [opts]}})
  end

  def leave(client, community) do
    GenServer.call(client, {:send, {"communities.leave", [community]}})
  end

  def remote_leave(client, opts) do
    GenServer.call(client, {:send, {"communities.remoteLeave", [opts]}})
  end
end
