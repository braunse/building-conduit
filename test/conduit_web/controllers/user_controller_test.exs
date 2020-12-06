defmodule ConduitWeb.UserControllerTest do
  use ConduitWeb.ConnCase

  alias Conduit.Accounts

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "user registration" do
    @tag :web
    test "should create and return user data when data is valid", %{conn: conn} do
      user = build(:user)
      conn = post conn, Routes.user_path(conn, :create), user: user
      json = json_response(conn, 201)["user"]

      assert json == %{
               "bio" => nil,
               "email" => user.email,
               "image" => nil,
               "username" => user.username
             }
    end

    @tag :web
    test "should not create user and render error when data is invalid", %{conn: conn} do
      user = build(:user, username: "")
      conn = post conn, Routes.user_path(conn, :create), user: user

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "can't be empty"
               ]
             }
    end

    @tag :web
    test "should not create user and render error when username has been taken", %{conn: conn} do
      existing_user = build(:user)
      {:ok, _} = Accounts.register_user(existing_user)
      user = build(:user, username: existing_user.username)
      conn = post conn, Routes.user_path(conn, :create), user: user

      assert json_response(conn, 422)["errors"] == %{
               "username" => [
                 "has already been taken"
               ]
             }
    end
  end

  describe "get current user" do
    @tag :web
    test "should return current user when authenticated", %{conn: conn} do
      user = build(:user)
      {:ok, registered_user} = Accounts.register_user(user)

      conn =
        conn
        |> make_authenticated(registered_user)
        |> get(Routes.user_path(conn, :current))

      json = json_response(conn, 200)["user"]
      token = json["token"]

      assert json == %{
               "email" => user.email,
               "bio" => nil,
               "image" => nil,
               "username" => user.username,
               "token" => token
             }

      refute is_nil(token)
      refute token == ""
    end

    @tag :web
    test "should return error when not authenticated", %{conn: conn} do
      conn =
        conn
        |> get(Routes.user_path(conn, :current))

      assert response(conn, 401) == ""
    end
  end
end
