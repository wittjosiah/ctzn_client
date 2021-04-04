defmodule CtznClient.Blob do
  @moduledoc """
  Documentation for `CtznClient.Blob`
  """

  def get(socket, database_id, key) do
    WebSockex.cast(socket, {:send, {"blob.get", [database_id, key]}})
  end

  def create(socket, blob) do
    WebSockex.cast(socket, {:send, {"blob.create", [blob]}})
  end

  def update(socket, key, blob) do
    WebSockex.cast(socket, {:send, {"blob.update", [key, blob]}})
  end

  def delete(socket, key) do
    WebSockex.cast(socket, {:send, {"blob.delete", [key]}})
  end
end
