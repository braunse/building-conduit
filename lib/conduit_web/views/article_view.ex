defmodule ConduitWeb.ArticleView do
  use ConduitWeb, :view

  alias Conduit.Blog.Article

  def render("index.json", %{articles: articles, total_count: total_count}) do
    %{
      articles: articles |> Enum.map(&render("article.json", %{article: &1})),
      articlesCount: total_count
    }
  end

  def render("show.json", %{article: article}) do
    %{article: render("article.json", %{article: article})}
  end

  def render("article.json", %{article: %Article.Projection{} = article}) do
    %{
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      tagList: article.tag_list,
      createdAt: NaiveDateTime.to_iso8601(article.published_at),
      updatedAt: NaiveDateTime.to_iso8601(article.updated_at),
      favoritesCount: article.favorite_count,
      favorited: false,
      author: %{
        username: article.author_username,
        bio: article.author_bio,
        image: article.author_image,
        following: false
      }
    }
  end
end
