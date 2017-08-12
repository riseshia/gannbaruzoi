defmodule Gannbaruzoi.TaskTest do
  use Gannbaruzoi.ModelCase

  alias Gannbaruzoi.Task

  @valid_attrs %{description: "some content", estimated_size: 42, status: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "type will not be root if it have parent" do
    parent = insert!(:task)
    valid_attrs_with_parent = Map.put(@valid_attrs, :parent_id, parent.id)
    task =
      Task.changeset(%Task{}, valid_attrs_with_parent)
      |> Repo.insert!

    assert "branch" = task.type
  end

  test "type will be root unless it have parent" do
    task =
      Task.changeset(%Task{}, @valid_attrs)
      |> Repo.insert!
    assert "root" = task.type
  end

  test "changeset with different user's parent task is invalid" do
    parent = insert!(:task, %{user_id: insert!(:user).id})
    invalid_parent_attrs =
      Map.merge(@valid_attrs, %{parent_id: parent.id, user_id: parent.user_id + 1})
    changeset = Task.changeset(%Task{}, invalid_parent_attrs)

    refute changeset.valid?
  end
end
