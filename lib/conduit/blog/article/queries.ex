defmodule Conduit.Blog.Article.Queries do
  import Ecto.Query

  alias Conduit.Blog.Article

  def by_slug(slug) do
    slug = String.downcase(slug)
    from(a in Article.Projection, where: a.slug == ^slug)
  end
end
