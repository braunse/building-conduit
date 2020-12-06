defmodule Conduit.Blog.Supervisor do
  use Supervisor

  alias Conduit.Blog

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [
      Blog.Author.AuthorProjector,
      Blog.Author.CreateAuthorForUserWorkflow,
      Blog.Article.Projector
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
