defmodule Conduit.AccountsTest do
  use Conduit.DataCase

  alias Conduit.Accounts

  describe "register_user/1" do
    @tag :integ
    @tag :wip
    test "should succeed with valid data" do
      attrs = build(:user)
      assert {:ok, user} = Accounts.register_user(attrs)

      assert user.bio == attrs.bio
      assert user.email == attrs.email
      assert user.image == attrs.image
      assert user.username == attrs.username
    end
  end
end
