defmodule CtznClient.Accounts do
  @moduledoc """
  Documentation for `CtznClient.Accounts`
  """

  @timeout 30_000

  def who_am_i(client, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"accounts.whoami", []}}, timeout)
  end

  def resume_session(client, session_id, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"accounts.resumeSession", [session_id]}}, timeout)
  end

  def login(client, login_info, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"accounts.login", [login_info]}}, timeout)
  end

  def logout(client, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"accounts.logout", []}}, timeout)
  end

  def register(client, register_info, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"accounts.register", [register_info]}}, timeout)
  end

  def request_change_password_code(client, username, timeout \\ @timeout) do
    GenServer.call(client, {:send, {"accounts.requestChangePasswordCode", [username]}}, timeout)
  end

  def change_password_using_code(client, username, code, new_password, timeout \\ @timeout) do
    GenServer.call(
      client,
      {:send, {"accounts.changePasswordUsingCode", [username, code, new_password]}},
      timeout
    )
  end

  def unregister(_client) do
    raise "unimplemented"
  end
end
