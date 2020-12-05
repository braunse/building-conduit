defmodule ConduitWeb.Auth.Pipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :conduit,
    module: ConduitWeb.Auth.Token,
    error_handler: ConduitWeb.Auth.ErrorHandler
end
