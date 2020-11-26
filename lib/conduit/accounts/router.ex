defmodule Conduit.Accounts.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.User.{RegisterUser, User}

  middleware Conduit.Support.Middleware.Validate

  dispatch [RegisterUser], to: User, identity: :user_uuid
end
