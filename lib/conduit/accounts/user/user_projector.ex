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
end
