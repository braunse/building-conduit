defmodule ConduitWeb.Plug.LoadArticleBySlug do
  @behaviour Plug

  alias Conduit.Blog

  @impl Plug
  def init(opts) do
    opts
  end

  @impl Plug
  def call(%Plug.Conn{params: %{"slug" => slug}} = conn, _opts) do
    article = Blog.get_article_by_slug!(slug)

    conn
    |> Plug.Conn.assign(:article, article)
  end
end
