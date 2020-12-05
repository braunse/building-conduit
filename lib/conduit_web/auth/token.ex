defmodule ConduitWeb.Auth.Token do
  use Guardian,
    otp_app: :conduit,
    issuer: "conduit"

  alias Conduit.Accounts
  alias Conduit.Accounts.User.UserProjection

  @impl Guardian
  def resource_from_claims(%{"sub" => "user-" <> user_uuid}) do
    case Accounts.find_user_by_uuid(user_uuid) do
      nil -> {:error, "Not found"}
      user -> {:ok, user}
    end
  end

  def resource_from_claims(_), do: {:error, "Unknown resource type"}

  @impl Guardian
  def subject_for_token(%UserProjection{uuid: user_uuid}, _claims) do
    {:ok, "user-#{user_uuid}"}
  end

  def subject_for_token(_, _), do: {:error, "Unknown resource type"}
end
