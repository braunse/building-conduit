defmodule Conduit.Blog.Author.CreateAuthorForUserWorkflow do
  use Commanded.Event.Handler,
    application: Conduit.Application,
    name: "Blog.Author.CreateAuthorForUserWorkflow",
    consistency: :strong

  alias Conduit.Accounts.User.UserRegistered
  alias Conduit.Blog

  def handle(%UserRegistered{} = user, _metadata) do
    with {:ok, _author} <- Blog.create_author(%{user_uuid: user.user_uuid, username: user.username}) do
      :ok
    else
      reply -> reply
    end
  end
end
