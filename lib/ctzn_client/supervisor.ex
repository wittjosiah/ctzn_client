defmodule CtznClient.Supervisor do
  @moduledoc """
  Documentation for `CtznClient.Supervisor`
  """

  use DynamicSupervisor

  alias CtznClient.Socket

  def start_child(params) do
    DynamicSupervisor.start_child(__MODULE__, {Socket, params})
  end

  def start_link(_) do
    DynamicSupervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  @impl true
  def init(_) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
