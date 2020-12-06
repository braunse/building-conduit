defmodule Conduit.Accounts.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.User.{RegisterUser, User}

  middleware Conduit.Support.Middleware.Validate
  middleware Conduit.Support.Middleware.Uniqueness

  identify User, by: :user_uuid, prefix: "user-"

  dispatch [RegisterUser], to: User
end
