defmodule Gannbaruzoi.TaskResolver do
  @moduledoc """
  The resolvers of task
  """
  alias Gannbaruzoi.Repo
  alias Gannbaruzoi.Task

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
    changeset = Task |> Repo.get!(attributes.id) |> Task.changeset(attributes)

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
end
