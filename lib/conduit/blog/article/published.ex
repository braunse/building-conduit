defmodule Conduit.Blog.Article.Published do
  @derive [Jason.Encoder]

  defstruct [
    :article_uuid,
    :slug,
    :title,
    :description,
    :body,
    :tag_list,
    :author_uuid
  ]
end
