defmodule Conduit.Blog.Article.Favorited do
  @derive [Jason.Encoder]
  defstruct [:article_uuid, :favorited_by_author_uuid, :favorite_count]
end
