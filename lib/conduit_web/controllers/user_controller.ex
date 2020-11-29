defmodule ConduitWeb.UserController do
  use ConduitWeb, :controller

  alias Conduit.Accounts

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.register_user(user_params) do
      conn
      |> put_status(:created)
      |> render("show.json", user: user)
    end
  end
end
