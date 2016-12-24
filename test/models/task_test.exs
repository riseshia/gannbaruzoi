defmodule Gannbaruzoi.TaskTest do
  use Gannbaruzoi.ModelCase

  alias Gannbaruzoi.Task

  @valid_attrs %{description: "some content", estimated_size: 42, status: true, type: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Task.changeset(%Task{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Task.changeset(%Task{}, @invalid_attrs)
    refute changeset.valid?
  end
end
