defmodule Conduit.Accounts.User.UserQueries do
  import Ecto.Query

  alias Conduit.Accounts.User.UserProjection

  def by_username(username) do
    from(p in UserProjection,
      where: p.username == ^username
    )
  end

  def by_email(email) do
    from(p in UserProjection,
      where: p.email == ^email
    )
  end
end
