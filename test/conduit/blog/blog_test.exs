defmodule Conduit.BlogTest do
  use Conduit.DataCase, async: false

  alias Conduit.Accounts
  alias Conduit.Blog
  alias Conduit.Blog.{Author, Article}
  import Conduit.SeedHelpers

  describe "publish article" do
    setup [
      :create_author
    ]

    @tag :integ
    test "should succeed with valid data", %{author: %Author.AuthorProjection{} = author} do
      article_params = build(:article, author_uuid: author.uuid)

      assert {:ok, %Article.Projection{} = article} = Blog.publish_article(author, article_params)
      assert article.slug == article_params.slug
      assert article.title == article_params.title
      assert article.description == article_params.description
      assert article.body == article_params.body
      assert article.tag_list == article_params.tag_list
      assert article.author_username == author.username
      assert article.author_bio == nil
      assert article.author_image == nil
    end
  end

  describe "list articles" do
    setup [
      :create_author,
      :publish_articles
    ]

    @tag :integ
    test "should list articled by published date descending", %{articles: [a1, a2]} do
      assert {[a2, a1], 2} == Blog.list_articles()
    end

    @tag :integ
    test "should limit articles", %{articles: [a1, a2]} do
      assert {[a2], 2} == Blog.list_articles(limit: 1)
    end

    @tag :integ
    test "should paginate articles", %{articles: [a1, a2]} do
      assert {[a1], 2} == Blog.list_articles(offset: 1)
    end

    @tag :integ
    test "should filter by author, not returning articles for unselected authors" do
      assert {[], 0} == Blog.list_articles(author: "unknown")
    end

    @tag :integ
    test "should filter by author, returning articles for selected authors", %{author: author, articles: [a1, a2]} do
      assert {[a2, a1], 2} == Blog.list_articles(author: author.username)
    end

    @tag :integ
    test "should filter by tag, not returning articles which do not contain the tag" do
      assert {[], 0} == Blog.list_articles(tag: "untagged")
    end

    @tag :integ
    test "should filter by tag, returning articles which contain the tag", %{articles: [a1, a2]} do
      assert {[a2, a1], 2} == Blog.list_articles(tag: Enum.at(a1.tag_list, 0))
    end
  end
end
