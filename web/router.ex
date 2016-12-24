defmodule Gannbaruzoi.Router do
  use Gannbaruzoi.Web, :router

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

  forward "/api", Absinthe.Plug, schema: Gannbaruzoi.Schema
  forward "/graphiql", Absinthe.Plug.GraphiQL, schema: Gannbaruzoi.Schema

  scope "/", Gannbaruzoi do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end
end
