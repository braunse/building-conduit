defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase, async: false

  alias Conduit.Accounts
  alias Conduit.Blog.Author

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "publish article" do
    @tag :web
    @tag :wip
    test "should create and return article when data is valid", %{conn: conn} do
      {:ok, user} = Accounts.register_user(build(:user))
      article = build(:article)

      conn =
        conn
        |> make_authenticated(user)
        |> post(Routes.article_path(conn, :create), article: article)

      json = json_response(conn, 201)["article"]
      createdAt = json["createdAt"]
      updatedAt = json["updatedAt"]

      assert json == %{
               "slug" => article.slug,
               "title" => article.title,
               "description" => article.description,
               "body" => article.body,
               "tagList" => article.tag_list,
               "createdAt" => createdAt,
               "updatedAt" => updatedAt,
               "favorited" => false,
               "favoritesCount" => 0,
               "author" => %{
                 "username" => user.username,
                 "bio" => nil,
                 "image" => nil,
                 "following" => false
               }
             }
      refute is_nil(createdAt)
      refute createdAt == ""
      refute is_nil(updatedAt)
      refute updatedAt == ""
    end
  end
end
