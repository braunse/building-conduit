defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller

  alias Plug.Conn
  alias Conduit.Accounts

  action_fallback ConduitWeb.FallbackController

  plug Guardian.Plug.EnsureAuthenticated when action in [:current]

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end

  def current(%Conn{} = conn, _params) do
    user = ConduitWeb.Auth.Token.Plug.current_resource(conn)

    with {:ok, token, _claims} <- ConduitWeb.Auth.generate_token(user) do
      conn |> render("session.json", user: user, token: token)
    end
  end
end
