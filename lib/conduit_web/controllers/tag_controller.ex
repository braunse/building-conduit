defmodule ConduitWeb.TagController do
  use ConduitWeb, :controller

  alias Conduit.Blog

  def index(conn, _params) do
    tag_names = Blog.list_tags()
    render(conn, "index.json", tag_names: tag_names)
  end
end
