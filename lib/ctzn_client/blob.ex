defmodule CtznClient.Blob do
  @moduledoc """
  Documentation for `CtznClient.Blob`
  """

  @timeout 30_000

  def get(client, database_id, key, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"blob.get", [database_id, key]}}, timeout)
  end

  def create(client, blob, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"blob.create", [blob]}}, timeout)
  end

  def update(client, key, blob, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"blob.update", [key, blob]}}, timeout)
  end

  def delete(client, key, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"blob.delete", [key]}}, timeout)
  end
end
