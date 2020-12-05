defmodule ConduitWeb.SessionControllerTest do
  use ConduitWeb.ConnCase

  alias Conduit.Accounts

  setup %{conn: conn} do
    {:ok, conn: conn |> put_req_header("accept", "application/json")}
  end

  describe "authenticate user" do
    @tag :web
    @tag :wip
    test "creates session and renders session data when valid", %{conn: conn} do
      user = build(:user)
      {:ok, _} = Accounts.register_user(user)

      conn =
        post conn, Routes.session_path(conn, :create),
          user: %{
            email: user.email,
            password: user.password
          }

      json = json_response(conn, 201)["user"]

      assert json == %{
               "bio" => nil,
               "email" => user.email,
               "image" => nil,
               "username" => user.username
             }
    end

    @tag :web
    @tag :wip
    test "does not create session and render error when password is inavlid", %{conn: conn} do
      user = build(:user)
      {:ok, _} = Accounts.register_user(user)

      conn =
        post conn, Routes.session_path(conn, :create),
          user: %{
            email: user.email,
            password: user.password <> "!not"
          }

      json = json_response(conn, 422)["errors"]

      assert json == %{
               "email or password" => ["is invalid"]
             }
    end

    @tag :web
    @tag :wip
    test "does not create session and render error when user is not found", %{conn: conn} do
      user = build(:user)

      conn =
        post conn, Routes.session_path(conn, :create),
          user: %{
            email: user.email,
            password: user.password
          }

      json = json_response(conn, 422)["errors"]

      assert json == %{
               "email or password" => ["is invalid"]
             }
    end
  end
end
