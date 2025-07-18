defmodule DingDingWeb.Router do
  use DingDingWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DingDingWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

 scope "/", DingDingWeb do
  pipe_through :browser

  # Home page now points to /goals
  live "/", GoalLive.Index, :index

  # Goals routes
  live "/goals", GoalLive.Index, :index
  live "/goals/new", GoalLive.Index, :new
  live "/goals/:id/edit", GoalLive.Index, :edit

  live "/goals/:id", GoalLive.Show, :show
  live "/goals/:id/show/edit", GoalLive.Show, :edit
end

  # Other scopes may use custom stacks.
  # scope "/api", DingDingWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:ding_ding, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DingDingWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
