defmodule ConduitWeb.Router do
  use ConduitWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :api_auth do
    plug Guardian.Plug.Pipeline, module: ConduitWeb.Auth.Token, error_handler: ConduitWeb.Auth.ErrorHandler
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.VerifyHeader, realm: "Token"
    plug Guardian.Plug.LoadResource, allow_blank: true
  end

  pipeline :api_auth_enforce do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/api", ConduitWeb do
    pipe_through [:api, :api_auth]

    get "/user", UserController, :current
    post "/users/login", SessionController, :create
    resources "/users", UserController, only: [:create]

    post "/articles", ArticleController, :create
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: ConduitWeb.Telemetry
    end
  end
end
