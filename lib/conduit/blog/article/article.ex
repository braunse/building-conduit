defmodule Conduit.Blog.Article do
  defstruct [
    :uuid,
    :slug,
    :title,
    :description,
    :body,
    :tag_list,
    :author_uuid,
    favorited_by_authors: MapSet.new(),
    favorite_count: 0
  ]

  alias Conduit.Blog.Article

  def execute(%Article{uuid: nil} = _new, %Article.Publish{} = publish) do
    %Article.Published{
      article_uuid: publish.article_uuid,
      slug: publish.slug,
      title: publish.title,
      description: publish.description,
      body: publish.body,
      tag_list: publish.tag_list,
      author_uuid: publish.author_uuid
    }
  end

  def execute(%Article{uuid: nil} = _not_found, _), do: {:error, :article_not_found}

  def execute(%Article{} = it, %Article.Favorite{} = favorite) do
    is_favorite = MapSet.member?(it.favorited_by_authors, favorite.favorited_by_author_uuid)

    cond do
      is_favorite ->
        nil

      true ->
        %Article.Favorited{
          article_uuid: it.uuid,
          favorited_by_author_uuid: favorite.favorited_by_author_uuid,
          favorite_count: it.favorite_count + 1
        }
    end
  end

  def execute(%Article{} = it, %Article.Unfavorite{} = unfavorite) do
    is_favorite = MapSet.member?(it.favorited_by_authors, unfavorite.unfavorited_by_author_uuid)

    cond do
      is_favorite ->
        %Article.Unfavorited{
          article_uuid: it.uuid,
          unfavorited_by_author_uuid: unfavorite.unfavorited_by_author_uuid,
          favorite_count: it.favorite_count - 1
        }

      true ->
        nil
    end
  end

  def apply(%Article{} = it, %Article.Published{} = published) do
    %Article{
      it
      | uuid: published.article_uuid,
        slug: published.slug,
        title: published.title,
        description: published.description,
        body: published.body,
        tag_list: published.tag_list,
        author_uuid: published.author_uuid
    }
  end

  def apply(%Article{} = it, %Article.Favorited{} = favorited) do
    %Article{
      it
      | favorited_by_authors:
          it.favorited_by_authors |> MapSet.put(favorited.favorited_by_author_uuid),
        favorite_count: favorited.favorite_count
    }
  end

  def apply(%Article{} = it, %Article.Unfavorited{} = unfavorited) do
    %Article{
      it
      | favorited_by_authors:
          it.favorited_by_authors |> MapSet.delete(unfavorited.unfavorited_by_author_uuid),
        favorite_count: unfavorited.favorite_count
    }
  end
end
