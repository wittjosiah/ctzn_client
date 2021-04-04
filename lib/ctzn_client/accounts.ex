defmodule CtznClient.Accounts do
  @moduledoc """
  Documentation for `CtznClient.Accounts`
  """

  def who_am_i(socket) do
    WebSockex.cast(socket, {:send, {"accounts.whoami", []}})
  end

  def resume_session(socket, session_id) do
    WebSockex.cast(socket, {:send, {"accounts.resumeSession", [session_id]}})
  end

  def login(socket, login_info) do
    WebSockex.cast(socket, {:send, {"accounts.login", [login_info]}})
  end

  def logout(socket) do
    WebSockex.cast(socket, {:send, {"accounts.logout", []}})
  end

  def register(socket, register_info) do
    WebSockex.cast(socket, {:send, {"accounts.register", [register_info]}})
  end

  def request_change_password_code(socket, username) do
    WebSockex.cast(socket, {:send, {"accounts.requestChangePasswordCode", [username]}})
  end

  def change_password_using_code(socket, username, code, new_password) do
    WebSockex.cast(
      socket,
      {:send, {"accounts.changePasswordUsingCode", [username, code, new_password]}}
    )
  end

  def unregister(_client) do
    raise "unimplemented"
  end
end
