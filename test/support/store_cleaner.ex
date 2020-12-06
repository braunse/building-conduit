defmodule Conduit.StoreCleaner do
  def restart_cleanly do
    Application.stop(:conduit)
    Application.stop(:commanded)
    Application.stop(:eventstore)

    reset_eventstore()
    reset_readstore()

    Application.ensure_all_started(:conduit)

    :ok
  end

  def reset_eventstore do
    config = Conduit.EventStore.config()

    {:ok, conn} =
      config
      |> EventStore.Config.parse()
      |> Postgrex.start_link()

    EventStore.Storage.Initializer.reset!(conn, config)
  end

  def reset_readstore do
    {:ok, conn} =
      Application.get_env(:conduit, Conduit.Repo)
      |> Keyword.delete(:pool)
      |> Postgrex.start_link()

    Postgrex.query!(conn, truncate_readstore_tables(), [])
  end

  def truncate_readstore_tables do
    """
      TRUNCATE TABLE
        accounts_users,
        projection_versions,
        blog_authors,
        blog_articles
      RESTART IDENTITY;
    """
  end
end
