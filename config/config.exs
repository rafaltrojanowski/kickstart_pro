# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :kickstart,
  ecto_repos: [Kickstart.Repo],
  env: Mix.env()

# Configures the endpoint
config :kickstart, KickstartWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9g+zSB+jRhoGRVbtdvkwqH/s64gXtnFSttTDyQ3wmga6Kp25xY5n9p/12/l1Ohr0",
  render_errors: [view: KickstartWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Kickstart.PubSub,
  live_view: [signing_salt: "Uz08k6+F1nr+RI7DgJFzosevFh9vP4Mj"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Torch Admin Dashboard
config :torch,
  otp_app: :kickstart,
  template_format: "eex" || "slime"

# Configures Social Login
config :ueberauth, Ueberauth,
  providers: [
    facebook: {Ueberauth.Strategy.Facebook, [default_scope: "email,public_profile"]},
    google: {Ueberauth.Strategy.Google, [default_scope: "email profile"]}
  ]

config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
  client_id: System.get_env("FACEBOOK_CLIENT_ID"),
  client_secret: System.get_env("FACEBOOK_CLIENT_SECRET")

config :ueberauth, Ueberauth.Strategy.Google.OAuth,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET")

# Payments with Stripe
config :gringotts, Gringotts.Gateways.Stripe,
  adapter: Gringotts.Gateways.Stripe,
  secret_key: System.get_env("STRIPE_SECRET_KEY"),
  default_currency: "USD"

config :ex_money, default_cldr_backend: Kickstart.Cldr

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
