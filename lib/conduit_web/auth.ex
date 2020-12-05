defmodule ConduitWeb.Auth do
  alias ConduitWeb.Auth.Token

  def generate_token(user) do
    Token.encode_and_sign(user)
  end
end
