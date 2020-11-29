defmodule ConduitWeb.ValidationView do
  use ConduitWeb, :view

  def render("error.json", %{errors: errors}) do
    errors =
      errors
      |> Stream.map(fn {field, markers} ->
        markers =
          markers
          |> Enum.map(fn {_validation, message} -> message end)

        {field, markers}
      end)
      |> Map.new()

    %{errors: errors}
  end
end
