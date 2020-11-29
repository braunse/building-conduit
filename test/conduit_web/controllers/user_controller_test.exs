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
end
