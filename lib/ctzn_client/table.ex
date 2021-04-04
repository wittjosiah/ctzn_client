defmodule CtznClient.Table do
  @moduledoc """
  Documentation for `CtznClient.Table`
  """

  def list(socket, database_id, table_schema_id, opts \\ []) do
    WebSockex.cast(socket, {:send, {"table.list", [database_id, table_schema_id, opts]}})
  end

  def get(socket, database_id, table_schema_id, key) do
    WebSockex.cast(socket, {:send, {"table.get", [database_id, table_schema_id, key]}})
  end

  def create(socket, database_id, table_schema_id, value) do
    WebSockex.cast(socket, {:send, {"table.create", [database_id, table_schema_id, value]}})
  end

  def update(socket, database_id, table_schema_id, key, value) do
    WebSockex.cast(socket, {:send, {"table.update", [database_id, table_schema_id, key, value]}})
  end

  def delete(socket, database_id, table_schema_id, key) do
    WebSockex.cast(socket, {:send, {"table.delete", [database_id, table_schema_id, key]}})
  end
end
