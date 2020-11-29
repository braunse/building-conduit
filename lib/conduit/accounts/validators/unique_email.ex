defmodule Conduit.Accounts.Validators.UniqueEmail do
  use Vex.Validator

  alias Conduit.Accounts

  def validate(value, _options) do
    Vex.Validators.By.validate(value, [function: &email_free?/1, message: "has already been taken"])
  end

  def email_free?(email) do
    case Accounts.find_user_by_email(email) do
      nil -> true
      _ -> false
    end
  end

end
