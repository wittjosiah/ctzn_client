defmodule CtznClient.DbMethod do
  @moduledoc """
  Documentation for `CtznClient.DbMethod`
  """

  @timeout 30_000

  defstruct [:args, :database, :method, :timeout, :wait]

  def call(client, db_method, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"dbmethod.call", [db_method]}}, timeout)
  end

  def get_result(client, db_result, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"dbmethod.getResult", [db_result]}}, timeout)
  end
end
