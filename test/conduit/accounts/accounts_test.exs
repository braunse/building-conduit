defmodule Conduit.AccountsTest do
  use Conduit.DataCase, async: false

  alias Conduit.Accounts

  describe "register_user/1" do
    @tag :integ
    @tag :wip
    test "should succeed with valid data" do
      attrs = build(:user)
      assert {:ok, user} = Accounts.register_user(attrs)

      assert user.email == attrs.email
      assert user.username == attrs.username
      assert user.bio == nil
      assert user.image == nil
    end
  end
end
