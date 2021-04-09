defmodule CtznClient.Users do
  @moduledoc """
  Documentation for `CtznClient.Users`
  """

  def lookup_db_url(client, user_id) do
    GenServer.call(client, {:send, {"users.lookupDbUrl", [user_id]}}, 20_000)
  end
end
