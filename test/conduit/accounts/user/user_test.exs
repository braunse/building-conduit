defmodule Conduit.Accounts.User.UserTest do
  use Conduit.AggregateCase, aggregate: Conduit.Accounts.User.User

  alias Conduit.Accounts.User.UserRegistered

  describe "register user" do
    @tag :unit
    @tag :wip
    test "should succeed when valid" do
      register = build(:register_user)
      uuid = register.user_uuid
      email = register.email
      username = register.username

      with_events(register, fn [evt] ->
        assert %UserRegistered{
                 user_uuid: ^uuid,
                 email: ^email,
                 username: ^username
               } = evt
      end)
    end
  end
end
