defmodule Conduit.Blog.Article.Queries do
  import Ecto.Query

  alias Conduit.Blog.Article

  defmodule ListOptions do
    defstruct limit: 20,
              offset: 0,
              author: nil,
              tag: nil

    use ExConstructor
  end

  def by_slug(slug) do
    slug = String.downcase(slug)
    from(a in Article.Projection, where: a.slug == ^slug)
  end

  def paginate(params, repo) do
    options = ListOptions.new(params)

    query = from(a in Article.Projection) |> filter_by_author(options) |> filter_by_tag(options)

    articles =
      from(a in query,
        order_by: [desc: a.published_at],
        limit: ^options.limit,
        offset: ^options.offset
      )
      |> repo.all()

    total_count = from(a in query, select: count(a.uuid)) |> repo.one()

    {articles, total_count}
  end

  defp filter_by_author(q, %ListOptions{author: nil}), do: q

  defp filter_by_author(q, %ListOptions{author: author}) do
    from(a in q, where: a.author_username == ^author)
  end

  defp filter_by_tag(q, %ListOptions{tag: nil}), do: q

  defp filter_by_tag(q, %ListOptions{tag: tag}) do
    from(a in q, where: fragment("? @> ?", a.tag_list, [^tag]))
  end
end
