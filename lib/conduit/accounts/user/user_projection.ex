defmodule Conduit.Accounts.User.UserProjection do
  use Ecto.Schema

  @primary_key {:uuid, :binary_id, autogenerate: false}

  schema "accounts_users" do
    field :bio, :string
    field :email, :string
    field :hashed_password, :string
    field :image, :string
    field :username, :string

    timestamps()
  end
end
