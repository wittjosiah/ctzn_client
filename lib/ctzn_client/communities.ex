defmodule CtznClient.Communities do
  @moduledoc """
  Documentation for `CtznClient.Communities`
  """

  def create(socket, create_info) do
    WebSockex.cast(socket, {:send, {"communities.create", [create_info]}})
  end

  def join(socket, community) do
    WebSockex.cast(socket, {:send, {"communities.join", [community]}})
  end

  def remote_join(socket, opts) do
    WebSockex.cast(socket, {:send, {"communities.remoteJoin", [opts]}})
  end

  def leave(socket, community) do
    WebSockex.cast(socket, {:send, {"communities.leave", [community]}})
  end

  def remote_leave(socket, opts) do
    WebSockex.cast(socket, {:send, {"communities.remoteLeave", [opts]}})
  end
end
