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
  validates :username, presence: [message: "can't be empty"], string: true, unique_username: true
  validates :email, presence: [message: "can't be empty"], string: true
  validates :hashed_password, presence: [message: "can't be empty"], string: true

  defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields, for: __MODULE__ do
    def unique_fields(_command), do: [
      username: {:unique_username, "has already been taken"}
    ]
  end
end
