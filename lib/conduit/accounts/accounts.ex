defmodule Conduit.Accounts do
  alias Conduit.Accounts.User.RegisterUser
  alias Conduit.Application

  def register_user(attrs \\ %{}) do
    attrs
    |> assign_uuid(:user_uuid)
    |> RegisterUser.new()
    |> Application.dispatch()
  end

  defp assign_uuid(attrs, key) when is_map(attrs), do: Map.put(attrs, key, UUID.uuid4())
  defp assign_uuid(attrs, key) when is_list(attrs), do: Keyword.put(attrs, key, UUID.uuid4())
end
