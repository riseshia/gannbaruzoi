defmodule Gannbaruzoi.UserTest do
  use Gannbaruzoi.ModelCase

  alias Gannbaruzoi.User

  @valid_attrs %{email: "some content"}
  @invalid_attrs %{}

  test "find_or_create_dummy with no registed user" do
    User.find_or_create_dummy
    assert 1 == Repo.aggregate(User, :count, :id)
  end
  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  describe "find_or_create_dummy/0" do
    test "find_or_create_dummy with registed user" do
      expected_email = "exist@email.com"
      %User{email: expected_email} |> Repo.insert!
      user = User.find_or_create_dummy
      assert expected_email == user.email
    end
  end

  describe "create_session/2" do
    test "create auth and tokens" do
      email = "hey-man@gmail.com"
      user = User.create_session(%User{email: email})

      assert email == user.auth.uid
      refute nil == user.auth
      assert nil == user.tokens["no-exist"]
      assert user.auth.token == user.tokens[user.auth.client].token
      assert 1111 == user.tokens[user.auth.client].expiry
    end
  end

  describe "delete_session/2" do
    test "deletes client" do
      client = "client-key-as-string"
      user =
        %User{tokens: %{ client => %{} }}
        |> User.delete_session(client)

      assert nil == Map.get(user.tokens, client)
    end
  end
end
