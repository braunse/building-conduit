defmodule ConduitWeb.FavoriteArticleController do
  use ConduitWeb, :controller

  alias Conduit.Blog
  alias Conduit.Blog.Article

  plug Guardian.Plug.EnsureAuthenticated when action in [:create, :delete]
  plug ConduitWeb.Plug.LoadArticleBySlug when action in [:create, :delete]

  def create(%Plug.Conn{assigns: %{article: article}} = conn, _params) do
    user = ConduitWeb.Auth.Token.Plug.current_resource(conn)
    author = Blog.get_author!(user.uuid)

    with {:ok, %Article.Projection{} = article} <- Blog.favorite_article(article, author) do
      conn
      |> put_status(:created)
      |> put_view(ConduitWeb.ArticleView)
      |> render("show.json", article: article)
    end
  end

  def delete(%Plug.Conn{assigns: %{article: article}} = conn, _params) do
    user = ConduitWeb.Auth.Token.Plug.current_resource(conn)
    author = Blog.get_author!(user.uuid)

    with {:ok, %Article.Projection{} = article} <- Blog.unfavorite_article(article, author) do
      conn
      |> put_status(:created)
      |> put_view(ConduitWeb.ArticleView)
      |> render("show.json", article: article)
    end
  end
end
