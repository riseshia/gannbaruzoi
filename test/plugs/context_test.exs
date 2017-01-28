defmodule Gannbaruzoi.ContextTest do
  use Gannbaruzoi.ConnCase

  alias Gannbaruzoi.{User, Repo}

  @email "hey!@gmail.com"
  @password "alice1234"

  test "current_user is assigned when valid header" do
    generate_user()
    auth = generate_auth()
    user = Repo.get_by!(User, email: @email)
    conn =
      build_conn()
      |> put_req_header("uid", auth.uid)
      |> put_req_header("client", auth.client)
      |> put_req_header("access-token", auth.token)
      |> Gannbaruzoi.Context.call(%{})

    assert ^user = conn.private.absinthe.context.current_user
    refute conn.halted
  end

  test "current_user is assigned when invalid header" do
    generate_user()
    auth = generate_auth()
    user = Repo.get_by!(User, email: @email)
    conn =
      build_conn()
      |> put_req_header("uid", "aaaa")
      |> put_req_header("client", auth.client)
      |> put_req_header("access-token", auth.token)
      |> Gannbaruzoi.Context.call(%{})

    assert 403 = conn.status
    assert conn.halted
  end

  test "current_user is not assigned when no header" do
    conn =
      build_conn()
      |> Gannbaruzoi.Context.call(%{})

    refute conn.halted
  end

  defp generate_user do
    %User{}
    |> User.changeset(%{email: @email, password: @password})
    |> Repo.insert!
  end

  defp generate_auth do
    Repo.get_by!(User, email: @email)
    |> User.build_session()
    |> Repo.update!
    |> Map.get(:auth)
  end
end
