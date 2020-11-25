defmodule Conduit.Accounts.User.RegisterUser do
  alias Conduit.Accounts.User.RegisterUser

  defstruct [
    :user_uuid,
    :username,
    :email,
    :password,
    :hashed_password,
  ]

  @type t() :: %RegisterUser{
    user_uuid: binary(),
    username: String.t(),
    email: String.t(),
    password: String.t(),
    hashed_password: String.t()
  }

  use ExConstructor
end
