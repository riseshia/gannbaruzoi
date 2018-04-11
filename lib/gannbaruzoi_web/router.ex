defmodule GannbaruzoiWeb.Router do
  use GannbaruzoiWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug Gannbaruzoi.Context
  end

  scope "/api" do
    pipe_through :graphql
    forward "/", Absinthe.Plug, schema: Gannbaruzoi.Schema
  end

  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: Gannbaruzoi.Schema

  scope "/", GannbaruzoiWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    get "/schema", PageController, :schema
  end
end
