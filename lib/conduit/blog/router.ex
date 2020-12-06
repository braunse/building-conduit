defmodule Conduit.Blog.Router do
  use Commanded.Commands.Router

  alias Conduit.Blog.Article
  alias Conduit.Blog.Author

  middleware Conduit.Support.Middleware.Validate
  middleware Conduit.Support.Middleware.Uniqueness

  identify Author, by: :author_uuid, prefix: "author-"
  identify Article, by: :article_uuid, prefix: "article-"

  dispatch [Author.CreateAuthor], to: Author
  dispatch [Article.Publish], to: Article
end
