defmodule Conduit.Accounts.Router do
  use Commanded.Commands.Router

  alias Conduit.Accounts.User.{RegisterUser, User}

  dispatch [RegisterUser], to: User, identity: :user_uuid
end
