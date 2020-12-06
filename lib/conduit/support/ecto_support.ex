defmodule Conduit.Support.EctoSupport do
  def tagged(result) do
    case result do
      nil -> {:error, :not_found}
      _ -> {:ok, result}
    end
  end
end
