defmodule Conduit.Blog.Author do
  defstruct [
    :uuid,
    :user_uuid,
    :username,
    :bio,
    :image
  ]

  alias Conduit.Blog.Author

  def execute(%Author{uuid: nil} = _new, %Author.CreateAuthor{} = create) do
    %Author.AuthorCreated{
      author_uuid: create.author_uuid,
      user_uuid: create.user_uuid,
      username: create.username
    }
  end

  def apply(%Author{} = self, %Author.AuthorCreated{} = created) do
    %Author{
      self
      | uuid: created.author_uuid,
        user_uuid: created.user_uuid,
        username: created.username
    }
  end
end
