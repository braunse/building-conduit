defmodule Conduit.Blog.Author.AuthorProjector do
  use Commanded.Projections.Ecto,
    application: Conduit.Application,
    repo: Conduit.Repo,
    name: "Blog.Author.AuthorProjector",
    consistency: :strong

  alias Conduit.Blog.Author

  project %Author.AuthorCreated{} = created, fn multi ->
    Ecto.Multi.insert(multi, :author, %Author.AuthorProjection{
      uuid: created.author_uuid,
      user_uuid: created.user_uuid,
      username: created.username,
      bio: nil,
      image: nil
    })
  end
end
