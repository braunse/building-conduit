defmodule ConduitWeb.FavoriteArticleControllerTest do
  use ConduitWeb.ConnCase, async: false

  import Conduit.SeedHelpers

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "favorite article" do
    setup [
      :create_author,
      :publish_articles
    ]

    @tag :web
    test "should be favorited and return article", %{
      conn: conn,
      author: author,
      author_user: user,
      articles: [a | _]
    } do
      conn =
        conn
        |> make_authenticated(user)
        |> post(Routes.favorite_article_path(conn, :create, a.slug))

      json = json_response(conn, 201)["article"]
      created_at = json["createdAt"]
      updated_at = json["updatedAt"]

      assert json == %{
               "slug" => a.slug,
               "title" => a.title,
               "description" => a.description,
               "body" => a.body,
               "tagList" => a.tag_list,
               "createdAt" => created_at,
               "updatedAt" => updated_at,
               "favorited" => true,
               "favoritesCount" => 1,
               "author" => %{
                 "username" => author.username,
                 "bio" => author.bio,
                 "image" => author.image,
                 "following" => false
               }
             }
    end
  end

  describe "unfavorite article" do
    setup [
      :create_author,
      :publish_articles,
      :register_user,
      :favorite_article
    ]

    @tag :web
    test "should unfavorite article  and return it", %{
      conn: conn,
      author: author,
      user: user,
      articles: [a | _]
    } do
      conn =
        conn
        |> make_authenticated(user)
        |> delete(Routes.favorite_article_path(conn, :delete, a.slug))

      json = json_response(conn, 201)["article"]
      created_at = json["createdAt"]
      updated_at = json["updatedAt"]

      assert json == %{
               "slug" => a.slug,
               "title" => a.title,
               "description" => a.description,
               "body" => a.body,
               "tagList" => a.tag_list,
               "createdAt" => created_at,
               "updatedAt" => updated_at,
               "favorited" => false,
               "favoritesCount" => 0,
               "author" => %{
                 "username" => author.username,
                 "bio" => author.bio,
                 "image" => author.image,
                 "following" => false
               }
             }
    end
  end
end
