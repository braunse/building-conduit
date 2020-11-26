defmodule Conduit.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use Conduit.DataCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Conduit.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Conduit.DataCase
      import Conduit.Factory
    end
  end

  setup _tags do
    Application.stop(:conduit)
    Application.stop(:commanded)
    Application.stop(:eventstore)

    reset_eventstore()
    reset_readstore()

    Application.ensure_all_started(:conduit)

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.

      assert {:error, changeset} = Accounts.create_user(%{password: "short"})
      assert "password is too short" in errors_on(changeset).password
      assert %{password: ["password is too short"]} = errors_on(changeset)

  """
  def errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  defp reset_eventstore do
    config = Conduit.EventStore.config()

    {:ok, conn} =
      config
      |> EventStore.Config.parse()
      |> Postgrex.start_link()

    EventStore.Storage.Initializer.reset!(conn, config)
  end

  defp reset_readstore do
    {:ok, conn} =
      Application.get_env(:conduit, Conduit.Repo)
      |> Keyword.delete(:pool)
      |> Postgrex.start_link()

    Postgrex.query!(conn, truncate_readstore_tables(), [])
  end

  defp truncate_readstore_tables do
    """
      TRUNCATE TABLE
        accounts_users,
        projection_versions
      RESTART IDENTITY;
    """
  end
end
