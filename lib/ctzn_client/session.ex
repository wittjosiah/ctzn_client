defmodule CtznClient.Session do
  @moduledoc """
  Documentation for `CtznClient.Session`.
  """

  @enforce_keys [:db_url, :session_id, :url, :user_id, :username]
  defstruct [:db_url, :session_id, :url, :user_id, :username]

  def parse(data) when is_map(data) do
    %__MODULE__{
      db_url: Map.get(data, "dbUrl"),
      session_id: Map.get(data, "sessionId"),
      url: Map.get(data, "url"),
      user_id: Map.get(data, "userId"),
      username: Map.get(data, "username")
    }
  end
end
