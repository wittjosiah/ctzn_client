defmodule CtznClient.Table do
  @moduledoc """
  Documentation for `CtznClient.Table`
  """

  @timeout 30_000

  def list(client, database_id, table_schema_id, opts \\ [], timeout \\ @timeout) do
    GenServer.call(client, {:send, {"table.list", [database_id, table_schema_id, opts]}}, timeout)
  end

  def get(client, database_id, table_schema_id, key, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"table.get", [database_id, table_schema_id, key]}}, timeout)
  end

  def create(client, database_id, table_schema_id, value, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"table.create", [database_id, table_schema_id, value]}}, timeout)
  end

  def update(client, database_id, table_schema_id, key, value, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"table.update", [database_id, table_schema_id, key, value]}}, timeout)
  end

  def delete(client, database_id, table_schema_id, key, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"table.delete", [database_id, table_schema_id, key]}}, timeout)
  end
end
