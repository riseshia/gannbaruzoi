defmodule Gannbaruzoi.PageControllerTest do
  use Gannbaruzoi.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Welcome to Phoenix!"
  end

  test "GET /schema", %{conn: conn} do
    conn = get(conn, "/schema")
    response = json_response(conn, 200)
    assert response["data"]["__schema"]
  end
end
