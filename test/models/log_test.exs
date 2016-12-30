defmodule Gannbaruzoi.LogTest do
  use Gannbaruzoi.ModelCase

  alias Gannbaruzoi.Log
  alias Gannbaruzoi.Repo

  @valid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Log.changeset(%Log{}, @valid_attrs)
    assert changeset.valid?
  end

  test "get last log from task" do
    task = insert_user()
           |> insert_task(description: "New todo", estimated_size: 1)
    log = insert_log(task)

    assert ^log = Log |> Log.by_task_id(task.id) |> Log.recent() |> Repo.one()
  end
end
