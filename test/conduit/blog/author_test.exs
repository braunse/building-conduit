defmodule Conduit.Blog.AuthorTest do
  use Conduit.DataCase, async: false

  import Commanded.Assertions.EventAssertions

  alias Conduit.Accounts
  alias Conduit.Accounts.User.UserProjection
  alias Conduit.Blog.Author.AuthorCreated

  describe "an author" do
    @tag :integ
    test "should be created when a user is registered" do
      assert {:ok, %UserProjection{} = user} = Accounts.register_user(build(:user))

      assert_receive_event(Conduit.Application, AuthorCreated, fn event ->
        assert event.user_uuid == user.uuid
        assert event.username == user.username
      end)
    end
  end
end
