defmodule Conduit.Blog.Article.Unfavorited do
  @derive [Jason.Encoder]
  defstruct [:article_uuid, :unfavorited_by_author_uuid, :favorite_count]
end
