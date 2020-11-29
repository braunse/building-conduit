defmodule Conduit.Accounts do
  alias Conduit.Accounts.User.{RegisterUser, UserProjection, UserQueries}
  alias Conduit.{Application, Repo}

  def register_user(attrs \\ %{}) do
    command = attrs
    |> RegisterUser.new()
    |> RegisterUser.assign_uuid()
    |> RegisterUser.downcase_username()
    |> RegisterUser.downcase_email()
    |> RegisterUser.hash_password()

    with :ok <- Application.dispatch(command, consistency: :strong) do
      tagged_get(UserProjection, command.user_uuid)
    else
      reply -> reply
    end
  end

  def find_user_by_username(username) do
    username
    |> String.downcase()
    |> UserQueries.by_username()
    |> Repo.one()
  end

  def find_user_by_email(email) do
    email
    |> String.downcase()
    |> UserQueries.by_email()
    |> Repo.one()
  end

  defp tagged_get(schema, id) do
    case Conduit.Repo.get(schema, id) do
      nil -> {:error, :not_found}
      val -> {:ok, val}
    end
  end

  defp assign_uuid(attrs, key) when is_map(attrs), do: Map.put(attrs, key, UUID.uuid4())
  defp assign_uuid(attrs, key) when is_list(attrs), do: Keyword.put(attrs, key, UUID.uuid4())
end
