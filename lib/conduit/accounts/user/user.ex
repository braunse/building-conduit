defmodule Conduit.Accounts.User.User do
  alias Conduit.Accounts.User.{User, RegisterUser, UserRegistered}

  defstruct [
    :uuid,
    :username,
    :email,
    :hashed_password
  ]

  @type t :: %User{
          uuid: binary() | nil,
          username: String.t() | nil,
          email: String.t() | nil,
          hashed_password: binary() | nil
        }

  @spec execute(User.t(), RegisterUser.t()) :: UserRegistered.t()
  def execute(%User{uuid: nil}, %RegisterUser{} = register) do
    %UserRegistered{
      user_uuid: register.user_uuid,
      username: register.username,
      email: register.email,
      hashed_password: register.hashed_password
    }
  end

  @spec apply(User.t(), UserRegistered.t()) :: User.t()
  def apply(%User{} = user, %UserRegistered{} = registered) do
    %User{
      user |
      uuid: registered.user_uuid,
      username: registered.username,
      email: registered.email,
      hashed_password: registered.hashed_password
    }
  end
end
