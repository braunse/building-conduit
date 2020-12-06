defmodule Conduit.Blog.Article.Slugger do
  import Ecto.Query

  alias Conduit.Repo
  alias Conduit.Blog.Article

  @spec slugify(String.t()) :: {:ok, String.t()} | {:error, any()}
  def slugify(title) do
    title
    |> Slugger.slugify_downcase()
    |> ensure_unique_slug()
  end

  defp ensure_unique_slug(slug, suffix \\ 1)

  defp ensure_unique_slug("", _suffix), do: ""

  defp ensure_unique_slug(_slug, suffix) when suffix > 100 do
    {:error, :get_a_new_slug_pls}
  end

  defp ensure_unique_slug(slug, suffix) do
    suffixed_slug = suffixed_slug(slug, suffix)

    if exists?(suffixed_slug) do
      ensure_unique_slug(slug, suffix + 1)
    else
      {:ok, suffixed_slug}
    end
  end

  defp suffixed_slug(slug, 1), do: slug
  defp suffixed_slug(slug, n), do: "#{slug}-#{to_string(n)}"

  defp exists?(slug) do
    count =
      from(a in Article.Queries.by_slug(slug), select: count(a.uuid))
      |> Repo.one()

    count > 0
  end
end
