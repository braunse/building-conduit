defmodule Conduit.Blog.Validators.UniqueArticleSlug do
  use Vex.Validator

  alias Conduit.Blog

  def validate(value, _options) do
    Vex.Validators.By.validate(value, [function: &is_slug_available?/1, message: "has already been taken"])
  end

  defp is_slug_available?(slug) do
    match?({:error, :not_found}, Blog.get_article_by_slug(slug))
  end
end
