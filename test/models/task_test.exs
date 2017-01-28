defmodule Gannbaruzoi.TaskTest do
  use Gannbaruzoi.ModelCase

  alias Gannbaruzoi.Task

  @valid_attrs %{description: "some content", estimated_size: 42,
                 status: true, type: "some content"}
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
    @valid_attrs_with_parent = %{@valid_attrs | parent_id: parent.id}
    task =
      Task.changeset(%Task{}, @valid_attrs_with_parent)
      |> Task.insert!

    refute task.type == "root"
  end

  test "type will be root unless it have parent" do
    task =
      Task.changeset(%Task{}, @valid_attrs)
      |> Task.insert!

    assert task.type == "root"
  end

  test "changeset with not exist is invalid" do
    @invalid_parent_attrs =
      %{@valid_attrs | parent_id: 0, user_id: parent.user_id + 1}
    changeset = Task.changeset(%Task{}, @invalid_parent_attrs)

    refute changeset.valid?
  end

  test "changeset with different user's parent task is invalid" do
    parent = insert!(:task)
    @invalid_parent_attrs =
      %{@valid_attrs | parent_id: parent.id, user_id: parent.user_id + 1}
    changeset = Task.changeset(%Task{}, @invalid_parent_attrs)

    refute changeset.valid?
  end
end
