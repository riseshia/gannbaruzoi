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
      %User{email: email} |> Repo.insert!
      auth = Repo.get_by!(User, email: email)
             |> User.create_session()
             |> Repo.update!
             |> Map.get(:auth)

      user = Repo.get_by!(User, email: email)

      assert email == auth.uid
      refute nil == auth
      assert nil == user.tokens["no-exist"]
      assert auth.token == user.tokens[auth.client]["token"]
      assert 1111 == user.tokens[auth.client]["expiry"]
    end
  end

  describe "delete_session/2" do
    test "deletes client" do
      email = "hey-man@gmail.com"
      %User{email: email} |> Repo.insert!
      client = Repo.get_by!(User, email: email)
               |> User.create_session()
               |> Repo.update!
               |> Map.get(:auth)
               |> Map.get(:client)
      user = Repo.get_by!(User, email: email)
             |> User.delete_session(client)
             |> Repo.update!

      assert nil == Map.get(user.tokens, client)
    end
  end

  describe "match_password?/2" do
    test "deletes client" do
      password = "alice1234"
      user = insert_user(email: "hey@gmail.com", password: password)
      assert User.match_password?(user, password)
    end
  end
end
