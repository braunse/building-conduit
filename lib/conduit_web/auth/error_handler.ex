defmodule ConduitWeb.Auth.ErrorHandler do
  @behaviour Guardian.Plug.ErrorHandler

  import Plug.Conn

  def auth_error(conn, {:unauthenticated, _reason}, _opts) do
    respond_with(conn, :unauthorized)
  end

  def auth_error(conn, {:no_resource_found, _reason}, _opts) do
    respond_with(conn, :unauthorized)
  end

  def auth_error(conn, {:already_authenticated, _reason}, _opts) do
    respond_with(conn, :forbidden)
  end

  defp respond_with(conn, status) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, "")
    |> halt()
  end
end
