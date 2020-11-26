defmodule Conduit.Accounts.Supervisor do
  use Supervisor

  alias Conduit.Accounts

  def start_link(_args) do
    Supervisor.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init(_args) do
    children = [
      Accounts.User.UserProjector
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
