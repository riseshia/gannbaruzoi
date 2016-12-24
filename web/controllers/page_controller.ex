defmodule Gannbaruzoi.PageController do
  use Gannbaruzoi.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
