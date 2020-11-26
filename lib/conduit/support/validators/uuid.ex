defmodule Conduit.Support.Validators.Uuid do
  use Vex.Validator

  def validate(value, _options) do
    Vex.Validators.By.validate(value, [
      function: &validate_uuid/1,
      allow_nil: false,
      allow_blank: false
    ])
  end

  defp validate_uuid(uuid) do
    case UUID.info(uuid) do
      {:ok, _} -> true
      {:error, _} -> false
    end
  end
end
