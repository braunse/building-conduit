defmodule Conduit.Blog.Article.Queries do
  import Ecto.Query

  alias Conduit.Blog.Author
  alias Conduit.Blog.Article

  defmodule ListOptions do
    defstruct limit: 20,
              offset: 0,
              author: nil,
              tag: nil,
              favorited: nil

    use ExConstructor
  end

  def by_slug(slug) do
    slug = String.downcase(slug)
    from(a in Article.Projection, where: a.slug == ^slug)
  end

  def by_id(uuid) do
    from(a in Article.Projection, where: a.uuid == ^uuid)
  end

  def favorited_by_article_author(article_uuid, author_uuid) do
    from(a in Article.FavoritedProjection,
      where: a.article_uuid == ^article_uuid and a.favorited_by_author_uuid == ^author_uuid
    )
  end

  def paginate(params, repo, reader \\ nil) do
    options = ListOptions.new(params)

    query =
      from(a in Article.Projection)
      |> filter_by_author(options)
      |> filter_by_tag(options)
      |> filter_by_favorite(options)

    articles =
      from(a in query,
        as: :article,
        order_by: [desc: a.published_at],
        limit: ^options.limit,
        offset: ^options.offset
      )
      |> include_favorited(reader)
      |> repo.all()

    total_count = from(a in query, select: count(a.uuid)) |> repo.one()

    {articles, total_count}
  end

  def list_tags() do
    from(t in Article.TagProjection)
  end

  def list_tag_names() do
    from(t in list_tags(), select: t.name)
  end

  defp filter_by_author(q, %ListOptions{author: nil}), do: q

  defp filter_by_author(q, %ListOptions{author: author}) do
    from(a in q, where: a.author_username == ^author)
  end

  defp filter_by_tag(q, %ListOptions{tag: nil}), do: q

  defp filter_by_tag(q, %ListOptions{tag: tag}) do
    from(a in q, where: fragment("? @> ?", a.tag_list, [^tag]))
  end

  defp filter_by_favorite(q, %ListOptions{favorited: nil}), do: q

  defp filter_by_favorite(q, %ListOptions{favorited: username}) do
    from(a in q,
      join: f in Article.FavoritedProjection,
      as: :favorited,
      on: f.article_uuid == a.uuid,
      where: f.favorited_by_author_username == ^username
    )
  end

  defp include_favorited(q, nil) do
    q
  end

  defp include_favorited(q, %Author.AuthorProjection{uuid: reader_uuid}) do
    from(a in q,
      left_join: f in Article.FavoritedProjection,
      as: :reader_favorited,
      on: f.article_uuid == a.uuid and f.favorited_by_author_uuid == ^reader_uuid,
      select: %{a | favorited: not is_nil(f.article_uuid)}
    )
  end
end
