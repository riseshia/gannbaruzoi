defmodule Gannbaruzoi.LogTest do
  use Gannbaruzoi.ModelCase

  alias Gannbaruzoi.Log

  @valid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Log.changeset(%Log{}, @valid_attrs)
    assert changeset.valid?
  end

  test "get first log from task" do
    user = insert_user()
    task = insert_task(user, description: "New todo", estimated_size: 1)
    log = insert_log(task.id)

    assert Log.first_of(task.id) == log
  end
end
