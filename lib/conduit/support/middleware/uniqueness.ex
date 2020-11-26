defmodule Conduit.Support.Middleware.Uniqueness do
  @behaviour Commanded.Middleware

  defprotocol UniqueFields do
    @fallback_to_any true
    @spec unique_fields(any) :: [{atom(), {atom(), String.t()}}]
    @doc "Returns the list of unique fields for this command"
    def unique_fields(command)
  end

  defimpl UniqueFields, for: Any do
    def unique_fields(_), do: []
  end

  alias Conduit.Support.UniquenessCache
  alias Commanded.Middleware.Pipeline

  import Pipeline

  def before_dispatch(%Pipeline{command: command} = pipeline) do
    case ensure_uniqueness(command) do
      :ok ->
        pipeline

      {:error, errors} ->
        pipeline
        |> respond({:error, :validation_failure, errors})
        |> halt()
    end
  end

  def after_dispatch(pipeline) do
    pipeline
  end

  def after_failure(%Pipeline{command: command} = pipeline) do
    #for {field, _error} <- UniqueFields.unique_fields(command) do
    #  UniquenessCache.release(command.__struct__, field, Map.get(command, field))
    #end
    pipeline
  end

  defp ensure_uniqueness(command) do
    ensure_uniqueness(command, UniqueFields.unique_fields(command))
  end

  defp ensure_uniqueness(_command, []) do
    :ok
  end

  defp ensure_uniqueness(command, [{field, error}|fields]) do
    with :ok <- UniquenessCache.claim(command.__struct__, field, Map.get(command, field)) do
      ensure_uniqueness(command, fields)
    else
      {:error, :already_taken} -> {:error, %{field => [error]}}
    end
  end
end
