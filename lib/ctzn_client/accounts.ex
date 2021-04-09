defmodule CtznClient.Accounts do
  @moduledoc """
  Documentation for `CtznClient.Accounts`
  """

  def who_am_i(client) do
    GenServer.call(client, {:send, {"accounts.whoami", []}})
  end

  def resume_session(client, session_id) do
    GenServer.call(client, {:send, {"accounts.resumeSession", [session_id]}})
  end

  def login(client, login_info) do
    GenServer.call(client, {:send, {"accounts.login", [login_info]}})
  end

  def logout(client) do
    GenServer.call(client, {:send, {"accounts.logout", []}})
  end

  def register(client, register_info) do
    GenServer.call(client, {:send, {"accounts.register", [register_info]}})
  end

  def request_change_password_code(client, username) do
    GenServer.call(client, {:send, {"accounts.requestChangePasswordCode", [username]}})
  end

  def change_password_using_code(client, username, code, new_password) do
    GenServer.call(
      client,
      {:send, {"accounts.changePasswordUsingCode", [username, code, new_password]}}
    )
  end

  def unregister(_client) do
    raise "unimplemented"
  end
end
