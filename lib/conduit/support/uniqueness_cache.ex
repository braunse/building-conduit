defmodule Conduit.Support.UniquenessCache do
  use GenServer

  def claim(context, field, value) do
    GenServer.call(__MODULE__, {:claim, context, field, value})
  end

  def release(context, field, value) do
    GenServer.call(__MODULE__, {:release, context, field, value})
  end

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(state), do: {:ok, state}

  def handle_call({:claim, context, field, value}, _from, state) do
    case Map.get(state, {context, field}) do
      nil ->
        set = MapSet.new([value])
        state = state |> Map.put({context, field}, set)
        {:reply, :ok, state}

      set ->
        if MapSet.member?(set, value) do
          {:reply, {:error, :already_taken}, state}
        else
          set = set |> MapSet.put(value)
          state = state |> Map.put({context, field}, set)
          {:reply, :ok, state}
        end
    end
  end

  def handle_call({:release, context, field, value}, _from, state) do
    case Map.get(state, {context, field}) do
      nil ->
        {:reply, :ok, state}

      set ->
        set = set |> MapSet.delete(value)

        state =
          if Enum.empty?(set) do
            state |> Map.delete({context, field})
          else
            state |> Map.put({context, field}, set)
          end

        {:reply, :ok, state}
    end
  end
end
