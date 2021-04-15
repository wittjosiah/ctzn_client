defmodule CtznClient.View do
  @moduledoc """
  Documentation for `CtznClient.View`
  """

  @timeout 30_000

  def get(client, view_schema_id, opts \\ [], timeout \\ @timeout) do
    GenServer.call(client, {:send, {"view.get", List.flatten([view_schema_id, opts])}}, timeout)
  end
end
