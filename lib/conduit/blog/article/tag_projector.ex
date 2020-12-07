defmodule Conduit.Blog.Article.TagProjector do
  use Commanded.Projections.Ecto,
    application: Conduit.Application,
    repo: Conduit.Repo,
    name: "Blog.Article.TagProjector",
    consistency: :strong

  alias Conduit.Blog.Article

  project %Article.Published{} = published, fn multi ->
    published.tag_list
    |> Enum.reduce(multi, fn tag, multi ->
      Ecto.Multi.insert(multi, "tag-#{tag}", %Article.TagProjection{name: tag},
        on_conflict: :nothing,
        conflict_target: :name
      )
    end)
  end
end
