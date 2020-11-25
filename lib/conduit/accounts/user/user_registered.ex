defmodule Conduit.Accounts.User.UserRegistered do
  alias Conduit.Accounts.User.UserRegistered

  @derive [Jason.Encoder]

  defstruct [
    :user_uuid,
    :username,
    :email,
    :hashed_password
  ]

  @type t() :: %UserRegistered{
    user_uuid: binary(),
    username: String.t(),
    email: String.t(),
    hashed_password: String.t()
  }
end
