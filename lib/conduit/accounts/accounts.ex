defmodule Conduit.Accounts do
  alias Conduit.Accounts.User.{RegisterUser, UserProjection}
  alias Conduit.Application

  def register_user(attrs \\ %{}) do
    command = attrs
    |> assign_uuid(:user_uuid)
    |> RegisterUser.new()

    with :ok <- Application.dispatch(command, consistency: :strong) do
      tagged_get(UserProjection, command.user_uuid)
    else
      reply -> reply
    end
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
