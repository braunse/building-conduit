defmodule Conduit.Factory do
  use ExMachina

  alias Conduit.Blog.Article

  def user_factory do
    %{
      email: sequence(:email, &"jake#{&1}@jake.jake"),
      username: sequence(:username, &"jake#{&1}"),
      password: sequence(:password, &"jakejake#{&1}"),
      bio: "I like to skateboard, dude",
      image: "https://i.stack.imgur.com/xHWG8.jpg"
    }
  end

  def register_user_factory do
    %Conduit.Accounts.User.RegisterUser{
      user_uuid: UUID.uuid4(),
      username: sequence(:username, &"jake#{&1}"),
      email: sequence(:email, &"jake#{&1}@jake.jake"),
      password: sequence(:password, &"jakejake#{&1}")
    }
  end

  def article_factory do
    %{
      slug: "how-to-train-your-dragon",
      title: "How to train your dragon",
      description: "Ever wonder how?",
      body: "You have to believe!",
      tag_list: ["dragons", "training"],
      author_uuid: UUID.uuid4()
    }
  end

  def publish_article_factory do
    article = article_factory()
    %Article.Publish{
      article_uuid: UUID.uuid4(),
      author_uuid: UUID.uuid4(),
      slug: article.slug,
      title: article.title,
      description: article.description,
      body: article.body,
      tag_list: article.tag_list
    }
  end

  def favorite_article_factory do
    %Article.Favorite{
      article_uuid: UUID.uuid4(),
      favorited_by_author_uuid: UUID.uuid4()
    }
  end

  def unfavorite_article_factory do
    %Article.Unfavorite{
      article_uuid: UUID.uuid4(),
      unfavorited_by_author_uuid: UUID.uuid4()
    }
  end
end
