defmodule ConduitWeb.ArticleControllerTest do
  use ConduitWeb.ConnCase, async: false

  alias Conduit.Accounts
  alias Conduit.Blog
  alias Conduit.Blog.Author
  import Conduit.SeedHelpers

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "publish article" do
    @tag :web
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

  describe "list articles" do
    setup [
      :create_author,
      :register_user,
      :publish_articles,
      :favorite_article
    ]

    @tag :web
    test "should return published articles by date published", %{
      conn: conn,
      author: author,
      user: user,
      articles: [a1, a2]
    } do
      conn = conn |> make_authenticated(user) |> get(Routes.article_path(conn, :index))
      json = json_response(conn, 200)

      assert %{"articles" => [j1, j2], "articlesCount" => 2} = json

      created_at_1 = j2["createdAt"]
      updated_at_1 = j2["updatedAt"]
      created_at_2 = j1["createdAt"]
      updated_at_2 = j1["updatedAt"]

      assert j1 == %{
               "slug" => a2.slug,
               "title" => a2.title,
               "description" => a2.description,
               "body" => a2.body,
               "tagList" => a2.tag_list,
               "createdAt" => created_at_2,
               "updatedAt" => updated_at_2,
               "favorited" => false,
               "favoritesCount" => 0,
               "author" => %{
                 "username" => author.username,
                 "bio" => author.bio,
                 "image" => author.image,
                 "following" => false
               }
             }

      assert j2 == %{
               "slug" => a1.slug,
               "title" => a1.title,
               "description" => a1.description,
               "body" => a1.body,
               "tagList" => a1.tag_list,
               "createdAt" => created_at_1,
               "updatedAt" => updated_at_1,
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

  describe "get article" do
    setup [
      :create_author,
      :publish_articles
    ]

    @tag :web
    test "should return published article by slug", %{
      conn: conn,
      author: author,
      articles: [article | _]
    } do
      conn = get(conn, Routes.article_path(conn, :show, article.slug))
      json = json_response(conn, 200)
      assert %{"article" => %{"createdAt" => createdAt, "updatedAt" => updatedAt}} = json

      assert json == %{
               "article" => %{
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
                   "username" => author.username,
                   "bio" => author.bio,
                   "image" => author.image,
                   "following" => false
                 }
               }
             }
    end

    @tag :web
    test "should return 404 when unknown slug", %{
      conn: conn
    } do
      conn = get(conn, Routes.article_path(conn, :show, "this-slug-does-not-exist"))
      assert conn.status == 404
    end
  end
end
