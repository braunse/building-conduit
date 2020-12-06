defmodule ConduitWeb.ArticleController do
  use ConduitWeb, :controller

  alias Conduit.Blog

  plug Guardian.Plug.EnsureAuthenticated when action in [:create]

  action_fallback ConduitWeb.FallbackController

  def create(conn, %{"article" => article_params}) do
    user = ConduitWeb.Auth.Token.Plug.current_resource(conn)
    author = Blog.get_author!(user.uuid)

    with {:ok, %{} = article} <- Blog.publish_article(author, article_params) do
      conn |> put_status(:created) |> render("show.json", article: article)
    end
  end

  def index(conn, params) do
    {articles, count} = Blog.list_articles(params)
    render(conn, "index.json", articles: articles, total_count: count)
  end

  def show(conn, %{"slug" => slug}) do
    with {:ok, article} <- Blog.get_article_by_slug(slug) do
      render(conn, "show.json", article: article)
    end
  end
end
