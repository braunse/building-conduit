defmodule Conduit.AccountsTest do
  use Conduit.DataCase, async: false

  alias Conduit.Accounts

  describe "register_user/1" do
    @tag :integ
    test "should succeed with valid data" do
      attrs = build(:user)
      assert {:ok, user} = Accounts.register_user(attrs)

      assert user.email == attrs.email
      assert user.username == attrs.username
      assert user.bio == nil
      assert user.image == nil
    end

    @tag :integ
    test "should fail with invalid data and return error" do
      attrs = build(:user, username: "")
      assert {:error, :validation_failure, errors} = Accounts.register_user(attrs)
      assert %{username: [{_, "can't be empty"}]} = errors
    end

    @tag :integ
    @tag :wip
    test "should fail with already-taken username" do
      {:ok, %{} = user} = Accounts.register_user(build(:user))
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, username: user.username))

      assert %{username: [{:unique_username, _}]} = errors
    end

    @tag :integ
    @tag :wip
    test "should fail when registering identical username at same time and return error" do
      1..2
      |> Enum.map(fn _ -> Task.async(fn -> Accounts.register_user(build(:user, username: "jake@jake.jake")) end) end)
      |> Enum.map(&Task.await/1)
    end
  end
end
