defmodule ConduitWeb.Auth.ErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler

  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> send_resp(401, to_string(type))
    |> halt()
  end
end
