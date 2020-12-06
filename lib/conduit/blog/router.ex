defmodule Conduit.Blog.Router do
  use Commanded.Commands.Router

  alias Conduit.Blog.Author

  middleware Conduit.Support.Middleware.Validate
  middleware Conduit.Support.Middleware.Uniqueness

  identify Author, by: :author_uuid, prefix: "author-"

  dispatch [Author.CreateAuthor], to: Author
end
