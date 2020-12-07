defmodule ConduitWeb.TagControllerTest do
  use ConduitWeb.ConnCase, async: false

  alias Conduit.Blog.Article
  import Conduit.SeedHelpers

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "list tags" do
    setup [
      :create_author,
      :publish_articles
    ]

    @tag :web
    test "should return list of tags", %{conn: conn, articles: articles} do
      tags =
        articles
        |> Stream.flat_map(fn %Article.Projection{tag_list: tag_list} -> tag_list end)
        |> MapSet.new()

      conn = get(conn, Routes.tag_path(conn, :index))
      json = json_response(conn, 200)
      got_tags = MapSet.new(json["tags"])

      assert tags == got_tags
    end
  end
end
