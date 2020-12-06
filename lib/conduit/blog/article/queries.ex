defmodule Conduit.Blog.Article.Queries do
  import Ecto.Query

  alias Conduit.Blog.Article

  defmodule Pagination do
    defstruct [
      limit: 20,
      offset: 0
    ]

    use ExConstructor
  end

  def by_slug(slug) do
    slug = String.downcase(slug)
    from(a in Article.Projection, where: a.slug == ^slug)
  end

  def paginate(params, repo) do
    pagination = Pagination.new(params)

    query = from(a in Article.Projection)
    articles = from(a in query, order_by: [desc: a.published_at], limit: ^pagination.limit, offset: ^pagination.offset) |> repo.all()
    total_count = from(a in query, select: count(a.uuid)) |> repo.one()

    {articles, total_count}
  end
end
