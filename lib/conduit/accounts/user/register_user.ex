defmodule Conduit.Accounts.User.RegisterUser do
  alias Conduit.Accounts.User.RegisterUser
  alias Conduit.Support.Middleware.Uniqueness

  defstruct [
    :user_uuid,
    :username,
    :email,
    :password,
    :hashed_password
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

  validates :username,
    presence: [message: "can't be empty"],
    string: true,
    unique_username: true,
    format: [
      with: ~r/^[a-z0-9]+$/,
      allow_nil: true,
      allow_blank: true,
      message: "Must contain only letters and numbers"
    ]

  validates :email,
    presence: [message: "can't be empty"],
    string: true,
    unique_email: true,
    format: [
      with: ~r/^\S+@\S+\.\S+$/,
      allow_nil: true,
      allow_blank: true,
      message: "must be an email address"
    ]

  validates :hashed_password, presence: [message: "can't be empty"], string: true

  validates :password, absence: [message: "must be hashed", allow_nil: true]

  defimpl Conduit.Support.Middleware.Uniqueness.UniqueFields, for: __MODULE__ do
    def unique_fields(_command),
      do: [
        %Uniqueness.Claim{
          context: Conduit.Accounts.User.User,
          value: :username,
          field: :username,
          validation: :unique_username,
          message: "has already been taken"
        },
        %Uniqueness.Claim{
          context: Conduit.Accounts.User.User,
          value: :email,
          field: :email,
          validation: :unique_email,
          message: "has already been taken"
        }
      ]
  end

  def assign_uuid(%RegisterUser{} = command) do
    %RegisterUser{command | user_uuid: UUID.uuid4()}
  end

  def downcase_username(%RegisterUser{username: username} = command) do
    %RegisterUser{command | username: String.downcase(username)}
  end

  def downcase_email(%RegisterUser{email: email} = command) do
    %RegisterUser{command | email: String.downcase(email)}
  end

  def hash_password(%RegisterUser{password: password} = command) do
    %RegisterUser{command | hashed_password: Conduit.Auth.hash_password(password), password: nil}
  end
end
