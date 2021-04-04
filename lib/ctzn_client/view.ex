defmodule CtznClient.View do
  @moduledoc """
  Documentation for `CtznClient.View`
  """

  def get(socket, view_schema_id, opts \\ []) do
    WebSockex.cast(socket, {:send, {"view.get", [view_schema_id, opts]}})
  end
end
