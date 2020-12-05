defmodule Conduit.Auth do
  alias Conduit.Accounts
  alias Conduit.Accounts.User.UserProjection

  def hash_password(password) do
    Argon2.hash_pwd_salt(password)
  end

  def verify_password(password, hash) do
    Argon2.verify_pass(password, hash)
  end

  defp verify_not_found() do
    Argon2.no_user_verify()
  end

  def authenticate(email, password) do
    email |> Accounts.find_user_by_email() |> do_authenticate(password)
  end

  defp do_authenticate(nil, _password) do
    verify_not_found()
    {:error, :unauthenticated}
  end

  defp do_authenticate(%UserProjection{} = user, password) do
    password
    |> verify_password(user.hashed_password)
    |> if do
      {:ok, user}
    else
      {:error, :unauthenticated}
    end
  end
end
