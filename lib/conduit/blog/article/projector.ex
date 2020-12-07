defmodule Conduit.Blog.Article.Projector do
  use Commanded.Projections.Ecto,
    application: Conduit.Application,
    repo: Conduit.Repo,
    name: "Blog.Article.Projector",
    consistency: :strong

  import Conduit.Support.EctoSupport
  import Conduit.Support.TimeSupport
  alias Conduit.Blog.Author
  alias Conduit.Blog.Article

  project %Article.Published{} = published, %{created_at: published_at}, fn multi ->
    published_at = to_utc_naive(published_at)

    multi
    |> Ecto.Multi.run(:author, fn repo, _changes ->
      repo.get(Author.AuthorProjection, published.author_uuid) |> tagged()
    end)
    |> Ecto.Multi.insert(:article, fn %{author: %Author.AuthorProjection{} = author} ->
      %Article.Projection{
        uuid: published.article_uuid,
        slug: published.slug,
        title: published.title,
        description: published.description,
        body: published.body,
        tag_list: published.tag_list,
        favorite_count: 0,
        published_at: published_at,
        author_uuid: author.uuid,
        author_bio: author.bio,
        author_image: author.image,
        author_username: author.username
      }
    end)
  end

  project %Article.Favorited{} = favorited, fn multi ->
    multi
    |> Ecto.Multi.insert(:favorited_article, %Article.FavoritedProjection{
      article_uuid: favorited.article_uuid,
      favorited_by_author_uuid: favorited.favorited_by_author_uuid
    })
    |> Ecto.Multi.update_all(:article, Article.Queries.by_id(favorited.article_uuid),
      set: [favorite_count: favorited.favorite_count]
    )
  end

  project %Article.Unfavorited{} = unfavorited, fn multi ->
    multi
    |> Ecto.Multi.delete_all(
      :favorited_article,
      Article.Queries.favorited_by_article_author(
        unfavorited.article_uuid,
        unfavorited.unfavorited_by_author_uuid
      )
    )
    |> Ecto.Multi.update_all(:article, Article.Queries.by_id(unfavorited.article_uuid),
      set: [favorite_count: unfavorited.favorite_count]
    )
  end
end
