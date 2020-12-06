defmodule Conduit.BlogTest do
  use Conduit.DataCase, async: false

  alias Conduit.Accounts
  alias Conduit.Blog
  alias Conduit.Blog.{Author, Article}

  describe "publish article" do
    setup [
      :create_author
    ]

    @tag :integ
    @tag :wip
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

  defp create_author(_context) do
    {:ok, user} = Accounts.register_user(build(:user))
    {:ok, author} = Blog.get_author(user.uuid)
    [author: author]
  end
end
