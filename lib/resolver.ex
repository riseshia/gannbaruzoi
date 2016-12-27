defmodule Gannbaruzoi.Resolver do
  alias Gannbaruzoi.Repo
  alias Gannbaruzoi.Task
  alias Gannbaruzoi.Log

  def all(_, _) do
     # TODO: scope with user_id
     task = Repo.all(Task)
     {:ok, task}
  end

  def create(_parent, attributes, _info) do
    changeset = Task.changeset(%Task{type: "root"}, attributes)

    case Repo.insert(changeset) do
      {:ok, task} -> {:ok, %{task: task}}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end

  def update(_parent, attributes, _info) do
    changeset = Repo.get!(Task, attributes.id) |> Task.changeset(attributes)

    case Repo.update(changeset) do
      {:ok, task} -> {:ok, %{task: task}}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end

  def delete(_parent, attributes, _info) do
    task = Repo.get!(Task, attributes.id)
    Repo.delete(task)
    {:ok, %{id: task.id}}
  end

  def create_log(%{task_id: task_id}, _info) do
    log =
      %Log{task_id: String.to_integer(task_id)}
      |> Log.changeset
      |> Repo.insert!
    {:ok, %{log: log}}
  end

  def delete_log(%{task_id: task_id}, _info) do
    log = Log.first_of(task_id)
    Repo.delete(log)
    {:ok, %{id: log.id}}
  end
end
