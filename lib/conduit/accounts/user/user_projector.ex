defmodule Conduit.Accounts.User.UserProjector do
  use Commanded.Projections.Ecto,
    application: Conduit.Application,
    repo: Conduit.Repo,
    name: "Accounts.User.UserProjector",
    consistency: :strong

  alias Conduit.Accounts.User.{UserProjection, UserRegistered}

  project %UserRegistered{} = registered, fn multi ->
    multi
    |> Ecto.Multi.insert(:user, %UserProjection{
      uuid: registered.user_uuid,
      username: registered.username,
      email: registered.email,
      hashed_password: registered.hashed_password,
      bio: nil,
      image: nil
    })
  end

  @impl Commanded.Projections.Ecto
  def after_update(%UserRegistered{} = registered, _metadata, _changes) do
    Conduit.Support.UniquenessCache.release(Conduit.Accounts.User.User, :username, registered.username)
    Conduit.Support.UniquenessCache.release(Conduit.Accounts.User.User, :email, registered.email)
    :ok
  end

  def after_update(_, _, _), do: :ok
end
