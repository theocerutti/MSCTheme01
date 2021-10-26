defmodule GothamWeb.Router do
  use GothamWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", GothamWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/clocks", ClockController, except: [:new, :edit]
    scope "/clocks" do
      get "/user/:userID", ClockController, :get_user_clock
      post "/user/:userID", ClockController, :user_clock
    end
    resources "/workingtimes", WorkingTimeController, except: [:new, :edit, :index]
    scope "/workingtimes" do
      get "/user/:userID", WorkingTimeController, :user_working_times
    end
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
      live_dashboard "/dashboard", metrics: GothamWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
