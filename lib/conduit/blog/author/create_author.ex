defmodule Conduit.Blog.Author.CreateAuthor do
  defstruct author_uuid: "",
            user_uuid: "",
            username: ""

  use ExConstructor
  use Vex.Struct

  alias Conduit.Blog.Author.CreateAuthor

  validates :author_uuid, uuid: true

  validates :user_uuid, uuid: true

  validates :username,
    presence: [message: "can't be empty"],
    format: [with: ~r/^[a-zA-Z0-9]+$/, allow_nil: true, allow_blank: true, message: "is invalid"],
    string: true

  def assign_uuid(%CreateAuthor{} = create_author, uuid) do
    %CreateAuthor{create_author | author_uuid: uuid}
  end
end
