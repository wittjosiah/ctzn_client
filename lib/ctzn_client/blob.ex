defmodule CtznClient.Blob do
  @moduledoc """
  Documentation for `CtznClient.Blob`
  """

  def get(client, database_id, key) do
    GenServer.call(client, {:send, {"blob.get", [database_id, key]}})
  end

  def create(client, blob) do
    GenServer.call(client, {:send, {"blob.create", [blob]}})
  end

  def update(client, key, blob) do
    GenServer.call(client, {:send, {"blob.update", [key, blob]}})
  end

  def delete(client, key) do
    GenServer.call(client, {:send, {"blob.delete", [key]}})
  end
end
