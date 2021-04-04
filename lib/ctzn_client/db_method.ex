defmodule CtznClient.DbMethod do
  @moduledoc """
  Documentation for `CtznClient.DbMethod`
  """

  defstruct [:args, :database, :method, :timeout, :wait]

  def call(socket, db_method) do
    WebSockex.cast(socket, {:send, {"dbmethod.call", [db_method]}})
  end

  def get_result(socket, db_result) do
    WebSockex.cast(socket, {:send, {"dbmethod.getResult", [db_result]}})
  end
end
