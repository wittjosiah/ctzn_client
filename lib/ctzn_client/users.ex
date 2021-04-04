defmodule CtznClient.Users do
  @moduledoc """
  Documentation for `CtznClient.Users`
  """

  def lookup_db_url(socket, user_id) do
    WebSockex.cast(socket, {:send, {"users.lookupDbUrl", [user_id]}})
  end
end
