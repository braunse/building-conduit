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
    test "should fail with already-taken username" do
      {:ok, %{} = user} = Accounts.register_user(build(:user))
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, username: user.username))

      assert %{username: [{:unique_username, _}]} = errors
    end

    @tag :integ
    test "should fail when registering identical username at same time and return error" do
      1..2
      |> Enum.map(fn _ -> Task.async(fn -> Accounts.register_user(build(:user, username: "jake")) end) end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integ
    test "should fail when username format is invalid and return an error" do
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, username: "j@ke"))
      assert %{username: [{:format, _}]} = errors
    end

    @tag :integ
    test "should normalize user names to lower-case" do
      assert {:ok, user} = Accounts.register_user(build(:user, username: "JaKe"))
      assert user.username == "jake"
    end

    @tag :integ
    test "should fail when email address already registered" do
      assert {:ok, existing_user} = Accounts.register_user(build(:user))
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, email: existing_user.email))
      assert %{email: [{:unique_email, _}]} = errors
    end

    @tag :integ
    test "should fail when email address registered twice concurrently" do
      1..2
      |> Enum.map(fn _ -> Task.async(fn -> Accounts.register_user(build(:user, email: "jake@jake.jake")) end) end)
      |> Enum.map(&Task.await/1)
    end

    @tag :integ
    test "should fail when email address format is invalid" do
      assert {:error, :validation_failure, errors} = Accounts.register_user(build(:user, email: "invalidemail"))
      assert %{email: [{:format, _}]} = errors
    end

    @tag :integ
    test "should convert email address to lower-case" do
      assert {:ok, user} = Accounts.register_user(build(:user, email: "JaKe@Jake.jaKE"))
      assert user.email == "jake@jake.jake"
    end

    @tag :integ
    @tag :wip
    test "should hash the password" do
      params = build(:user)
      assert {:ok, user} = Accounts.register_user(params)
      assert Conduit.Auth.verify_password(params.password, user.hashed_password)
    end
  end
end
