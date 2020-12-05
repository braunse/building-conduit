defmodule ConduitWeb.SessionController do
  use ConduitWeb, :controller

  alias Conduit.Auth
  alias Conduit.Accounts.User.UserProjection

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"user" => %{"email" => email, "password" => password}}) do
    with {:ok, %UserProjection{} = user} <- Auth.authenticate(email, password),
         {:ok, token, _claim} <- ConduitWeb.Auth.generate_token(user) do
      conn
      |> put_status(:created)
      |> put_view(ConduitWeb.UserView)
      |> render("session.json", user: user, token: token)
    else
      {:error, :unauthenticated} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(ConduitWeb.ValidationView)
        |> render("error.json", errors: %{"email or password" => [{:is_invalid, "is invalid"}]})
    end
  end
end
