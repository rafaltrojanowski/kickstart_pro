defmodule KickstartWeb.Router do
  use KickstartWeb, :router

  import KickstartWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/admin", KickstartWeb.Admin, as: :admin do
    pipe_through [:browser, :require_authenticated_admin]
    resources "/posts", PostController
    resources "/users", UserController
    resources "/pricing", PricingPlanController
    resources "/subscriptions", SubscriptionController, only: [:show, :index, :delete]
    resources "/faqs", FaqController
    resources "/", DashboardController
  end

  scope "/auth", KickstartWeb do
    pipe_through([:browser])
    get("/:provider", SocialAuthController, :request)
    get("/:provider/callback", SocialAuthController, :callback)
    post("/:provider/callback", SocialAuthController, :callback)
  end

  scope "/", KickstartWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/posts", PostController, param: "slug", only: [:index, :show]
    resources "/pricing", PricingPlanController, only: [:index]
    resources "/faq", FaqController, only: [:index]
  end

  # Other scopes may use custom stacks.
  # scope "/api", KickstartWeb do
  #   pipe_through :api
  # end

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
      pipe_through :browser
      live_dashboard "/dashboard", metrics: KickstartWeb.Telemetry
    end
  end

  ## Authentication routes

  scope "/", KickstartWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    get "/users/register", UserRegistrationController, :new
    post "/users/register", UserRegistrationController, :create
    get "/users/log_in", UserSessionController, :new
    post "/users/log_in", UserSessionController, :create
    get "/users/reset_password", UserResetPasswordController, :new
    post "/users/reset_password", UserResetPasswordController, :create
    get "/users/reset_password/:token", UserResetPasswordController, :edit
    put "/users/reset_password/:token", UserResetPasswordController, :update
  end

  scope "/", KickstartWeb do
    pipe_through [:browser, :require_authenticated_user]

    get "/users/settings", UserSettingsController, :edit
    put "/users/settings", UserSettingsController, :update
    get "/users/settings/confirm_email/:token", UserSettingsController, :confirm_email
    get "/users/dashboard/home", DashboardController, :index
    get "/users/dashboard/billing", BillingController, :index

    resources "/subscriptions", SubscriptionController, only: [:new, :create] do
      put "/cancel", SubscriptionController, :cancel
    end
  end

  scope "/", KickstartWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete
    get "/users/confirm", UserConfirmationController, :new
    post "/users/confirm", UserConfirmationController, :create
    get "/users/confirm/:token", UserConfirmationController, :confirm
  end
end
