defmodule CtznClient.DbMethod do
  @moduledoc """
  Documentation for `CtznClient.DbMethod`
  """

  defstruct [:args, :database, :method, :timeout, :wait]

  def call(client, db_method) do
    GenServer.call(client, {:send, {"dbmethod.call", [db_method]}})
  end

  def get_result(client, db_result) do
    GenServer.call(client, {:send, {"dbmethod.getResult", [db_result]}})
  end
end
