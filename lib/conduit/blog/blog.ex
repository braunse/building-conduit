defmodule Conduit.Blog do
  alias Conduit.Repo
  alias Conduit.Blog.Author

  def create_author(%{user_uuid: uuid} = attrs) do
    create_author = attrs |> Author.CreateAuthor.new() |> Author.CreateAuthor.assign_uuid(uuid)

    with :ok <- Conduit.Application.dispatch(create_author, consistency: :strong) do
      get_author(uuid)
    else
      reply -> reply
    end
  end

  def get_author(uuid) do
    case Repo.get(Author.AuthorProjection, uuid) do
      nil -> {:error, :not_found}
      e -> {:ok, e}
    end
  end
end
