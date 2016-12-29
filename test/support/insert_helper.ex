defmodule Gannbaruzoi.InsertHelper do
  alias Gannbaruzoi.{Repo, Task, Log, User}

  def insert_user(attrs \\ []) do
    changes = Map.merge(%{
      email: "default@email.com"
    }, Map.new(attrs))

    %User{}
    |> User.changeset(changes)
    |> Repo.insert!
  end

  def insert_task(user, attrs \\ []) do
    changes = Map.merge(%{
      description: "Default Todo",
      estimated_size: 1,
      type: "parent"
    }, Map.new(attrs))

    %Task{user_id: user.id}
    |> Task.changeset(changes)
    |> Repo.insert!
  end

  def insert_log(task_id) do
    %Log{task_id: task_id}
    |> Repo.insert!
  end
end
