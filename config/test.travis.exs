use Mix.Config

# Configure your database
config :gannbaruzoi, Gannbaruzoi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "gannbaruzoi_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
