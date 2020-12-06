defmodule Conduit.Blog do
  alias Conduit.Repo
  alias Conduit.Blog.Author
  alias Conduit.Blog.Article

  def create_author(%{user_uuid: uuid} = attrs) do
    create_author = attrs |> Author.CreateAuthor.new() |> Author.CreateAuthor.assign_uuid(uuid)

    with :ok <- Conduit.Application.dispatch(create_author, consistency: :strong) do
      get_author(uuid)
    else
      reply -> reply
    end
  end

  def get_author(uuid) do
    get(Author.AuthorProjection, uuid)
  end

  def get_author!(uuid) do
    get!(Author.AuthorProjection, uuid)
  end

  def publish_article(%Author.AuthorProjection{} = author, attrs) do
    uuid = UUID.uuid4()

    publish_article =
      attrs
      |> Article.Publish.new()
      |> Article.Publish.assign_uuid(uuid)
      |> Article.Publish.assign_author(author)
      |> Article.Publish.generate_url_slug()

    with :ok <- Conduit.Application.dispatch(publish_article, consistency: :strong) do
      get_article(uuid)
    else
      reply -> reply
    end
  end

  def get_article(uuid), do: get(Article.Projection, uuid)
  def get_article!(uuid), do: get!(Article.Projection, uuid)

  def get_article_by_slug(slug) do
    slug
    |> Article.Queries.by_slug()
    |> Repo.one()
    |> case do
      nil -> {:error, :not_found}
      e -> {:ok, e}
    end
  end

  def list_articles(params \\ %{}) do
    {articles, count} = Article.Queries.paginate(params, Repo)
  end

  defp get(schema, id) do
    case Repo.get(schema, id) do
      nil -> {:error, :not_found}
      e -> {:ok, e}
    end
  end

  defp get!(schema, id) do
    case get(schema, id) do
      {:error, e} -> raise "#{inspect(e)}"
      {:ok, it} -> it
    end
  end
end
