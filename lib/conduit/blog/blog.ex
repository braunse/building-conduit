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

  def get_article_by_slug!(slug) do
    slug
    |> Article.Queries.by_slug()
    |> Repo.one!()
  end

  def list_articles(params \\ %{}, reader \\ nil) do
    Article.Queries.paginate(params, Repo, reader)
  end

  def favorite_article(
        %Article.Projection{uuid: article_uuid} = _article,
        %Author.AuthorProjection{uuid: author_uuid} = _author
      ) do
    favorite_article = %Article.Favorite{
      article_uuid: article_uuid,
      favorited_by_author_uuid: author_uuid
    }

    with :ok <- Conduit.Application.dispatch(favorite_article, consistency: :strong),
         {:ok, article} <- get(Article.Projection, article_uuid) do
      {:ok, %Article.Projection{article | favorited: true}}
    else
      reply -> reply
    end
  end

  def unfavorite_article(
        %Article.Projection{uuid: article_uuid} = _article,
        %Author.AuthorProjection{uuid: author_uuid} = _author
      ) do
    unfavorite_article = %Article.Unfavorite{
      article_uuid: article_uuid,
      unfavorited_by_author_uuid: author_uuid
    }

    with :ok <- Conduit.Application.dispatch(unfavorite_article, consistency: :strong),
         {:ok, article} <- get(Article.Projection, article_uuid) do
      {:ok, %Article.Projection{article | favorited: false}}
    else
      reply -> reply
    end
  end

  def list_tags() do
    Article.Queries.list_tag_names()
    |> Repo.all()
  end

  defp get(schema, id) do
    case Repo.get(schema, id) do
      nil -> {:error, :not_found}
      e -> {:ok, e}
    end
  end

  defp get!(schema, id) do
    Repo.get!(schema, id)
  end
end
