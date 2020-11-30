defmodule Conduit.Support.Middleware.Uniqueness do
  @behaviour Commanded.Middleware

  defmodule Claim do
    defstruct [
      :context,
      :value,
      :field,
      :validation,
      :message
    ]

    @type t :: %__MODULE__{
            context: atom(),
            value: atom(),
            field: atom(),
            validation: atom(),
            message: String.t()
          }
  end

  defprotocol UniqueFields do
    @fallback_to_any true
    @spec unique_fields(any) :: [Claim.t()]
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
    for %Claim{} = claim <- UniqueFields.unique_fields(command) do
      UniquenessCache.release(claim.context, claim.value, Map.get(command, claim.field))
    end

    pipeline
  end

  defp ensure_uniqueness(command) do
    ensure_uniqueness(command, UniqueFields.unique_fields(command))
  end

  defp ensure_uniqueness(_command, []) do
    :ok
  end

  defp ensure_uniqueness(command, [%Claim{} = claim | fields]) do
    with :ok <- UniquenessCache.claim(claim.context, claim.value, Map.get(command, claim.field)) do
      ensure_uniqueness(command, fields)
    else
      {:error, :already_taken} -> {:error, %{claim.field => [{claim.validation, claim.message}]}}
    end
  end
end
