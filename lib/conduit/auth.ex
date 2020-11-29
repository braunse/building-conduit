defmodule Conduit.Auth do
  def hash_password(password) do
    Argon2.hash_pwd_salt(password)
  end

  def verify_password(password, hash) do
    Argon2.verify_pass(password, hash)
  end
end
