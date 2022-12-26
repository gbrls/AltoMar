import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :alto_mar, AltoMar.Repo,
  database: Path.expand("../alto_mar_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :alto_mar, AltoMarWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "I9A8z+TDZQo6E1NT4qtNK4olyf4LrLiP0MBEC+Bmq0wQ2KLuhIVDCu6JyndH0lOr",
  server: false

# In test we don't send emails.
config :alto_mar, AltoMar.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
