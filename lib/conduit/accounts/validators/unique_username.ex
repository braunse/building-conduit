defmodule Conduit.Accounts.Validators.UniqueUsername do
  use Vex.Validator

  alias Conduit.Accounts

  def validate(value, _options) do
    Vex.Validators.By.validate(value, [function: &username_free?/1, message: "has already been taken"])
  end

  def username_free?(username) do
    case Accounts.find_user_by_username(username) do
      nil -> true
      _ -> false
    end
  end
end
