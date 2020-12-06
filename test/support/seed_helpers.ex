defmodule Conduit.SeedHelpers do
  import Conduit.Factory

  alias Conduit.Accounts
  alias Conduit.Blog

  def create_author(_context) do
    {:ok, user} = Accounts.register_user(build(:user))
    {:ok, author} = Blog.get_author(user.uuid)

    [
      author_user: user,
      author: author
    ]
  end

  def publish_articles(%{author: author}) do
    {:ok, article1} = Blog.publish_article(author, build(:article))

    {:ok, article2} =
      Blog.publish_article(
        author,
        build(:article,
          title: "How to train your second dragon",
          description: "So toothless",
          body: "It's a dragon!"
        )
      )

    [articles: [article1, article2]]
  end

end
