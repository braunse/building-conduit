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
  use Vex.Struct

  validates :user_uuid, uuid: true
  validates :username, presence: [message: "can't be empty"], string: true
  validates :email, presence: [message: "can't be empty"], string: true
  validates :hashed_password, presence: [message: "can't be empty"], string: true
end