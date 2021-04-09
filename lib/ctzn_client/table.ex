defmodule CtznClient.Table do
  @moduledoc """
  Documentation for `CtznClient.Table`
  """

  def list(client, database_id, table_schema_id, opts \\ []) do
    GenServer.call(client, {:send, {"table.list", [database_id, table_schema_id, opts]}})
  end

  def get(client, database_id, table_schema_id, key) do
    GenServer.call(client, {:send, {"table.get", [database_id, table_schema_id, key]}})
  end

  def create(client, database_id, table_schema_id, value) do
    GenServer.call(client, {:send, {"table.create", [database_id, table_schema_id, value]}})
  end

  def update(client, database_id, table_schema_id, key, value) do
    GenServer.call(client, {:send, {"table.update", [database_id, table_schema_id, key, value]}})
  end

  def delete(client, database_id, table_schema_id, key) do
    GenServer.call(client, {:send, {"table.delete", [database_id, table_schema_id, key]}})
  end
end
