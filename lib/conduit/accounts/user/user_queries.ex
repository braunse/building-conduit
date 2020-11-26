defmodule Conduit.Accounts.User.UserQueries do
  import Ecto.Query

  alias Conduit.Accounts.User.UserProjection

  def by_username(username) do
    from(p in UserProjection,
      where: p.username == ^username
    )
  end
end
