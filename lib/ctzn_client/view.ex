defmodule CtznClient.View do
  @moduledoc """
  Documentation for `CtznClient.View`
  """

  def get(client, view_schema_id, opts \\ []) do
    GenServer.call(client, {:send, {"view.get", List.flatten([view_schema_id, opts])}})
  end
end
