defmodule Gannbaruzoi.UserTest do
  use Gannbaruzoi.ModelCase

  alias Gannbaruzoi.User

  @valid_attrs %{email: "some content"}
  @invalid_attrs %{}

  test "find_or_create_dummy with no registed user" do
    User.find_or_create_dummy
    assert 1 == Repo.aggregate(User, :count, :id)
  end

  test "find_or_create_dummy with registed user" do
    expected_email = "exist@email.com"
    %User{email: expected_email} |> Repo.insert!
    user = User.find_or_create_dummy
    assert expected_email == user.email
  end

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
