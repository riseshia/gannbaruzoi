defmodule Gannbaruzoi.UserTest do
  use Gannbaruzoi.ModelCase

  import Gannbaruzoi.Factory

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
    test "find registered user" do
      expected_email = "exist@email.com"
      insert!(:user, %{email: expected_email})
      user = User.find_or_create_dummy
      assert expected_email == user.email
    end

    test "create dummy user" do
      assert %User{} = User.find_or_create_dummy
    end
  end


  describe "build_session/2" do
    test "create auth and tokens" do
      email = "hey-man@gmail.com"
      auth = generate_auth(email)
      user = Repo.get_by!(User, email: email)

      assert auth
      assert email == auth.uid
      assert user.tokens[auth.client]
      refute user.tokens["no-exist"]
    end
  end

  describe "delete_session/2" do
    test "deletes client" do
      email = "hey-man@gmail.com"
      auth = generate_auth(email)
      client = auth.client
      user = Repo.get_by!(User, email: email)
             |> User.delete_session(client)
             |> Repo.update!

      refute Map.get(user.tokens, client)
    end
  end

  describe "valid_token?" do
    test "returns true or false" do
      email = "hey-man@gmail.com"
      auth = generate_auth(email)

      user = Repo.get_by!(User, email: email)
      now = DateTime.utc_now() |> DateTime.to_unix()
      fifteen_days_later = now + 60 * 60 * 24 * 14

      assert User.valid_token?(user, auth.client, auth.access_token)
      refute User.valid_token?(user, "wrong client", auth.access_token)
      refute User.valid_token?(user, auth.client, "wrong token")
      refute User.valid_token?(user, auth.client, auth.access_token,
                               fifteen_days_later)
    end
  end

  describe "match_password?/2" do
    test "returns true or false" do
      password = "alice1234"
      email = "hey!@gmail.com"
      insert!(:user, %{email: email, password: password})
      user = Repo.get_by!(User, email: email)
      assert User.match_password?(user, password)
      refute User.match_password?(user, "wrong-password")
    end
  end

  defp generate_auth(email) do
    insert!(:user, %{email: email})
    Repo.get_by!(User, email: email)
    |> User.build_session()
    |> Repo.update!
    |> Map.get(:auth)
  end
end
