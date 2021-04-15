defmodule CtznClient.Users do
  @moduledoc """
  Documentation for `CtznClient.Users`
  """

  @timeout 30_000

  def lookup_db_url(client, user_id, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"users.lookupDbUrl", [user_id]}}, timeout)
  end
end
