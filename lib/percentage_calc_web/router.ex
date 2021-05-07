defmodule PercentageCalcWeb.Router do
  use PercentageCalcWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PercentageCalcWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :admins_only do
    plug :admin_basic_auth
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PercentageCalcWeb do
    pipe_through :browser

    live "/", PageLive, :index
    get "/stats", StatsController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", PercentageCalcWeb do
  #   pipe_through :api
  # end

  import Phoenix.LiveDashboard.Router

  scope "/" do
    pipe_through [:browser, :admins_only]

    live_dashboard "/dashboard",
      metrics: PercentageCalcWeb.Telemetry,
      ecto_repos: [PercentageCalc.Repo]
  end

  defp admin_basic_auth(conn, _opts) do
    username = System.fetch_env!("AUTH_USERNAME")
    password = System.fetch_env!("AUTH_PASSWORD")
    Plug.BasicAuth.basic_auth(conn, username: username, password: password)
  end
end
