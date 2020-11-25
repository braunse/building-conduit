defmodule Conduit.Application do
  use Commanded.Application, otp_app: :conduit

  router(Conduit.Accounts.Router)
end
