defmodule Gannbaruzoi.TaskResolver do
  @moduledoc """
  The resolvers of task
  """
  alias Gannbaruzoi.{Repo, Task}
  alias Absinthe.Relay.Connection

  def all(pagination_args, _) do
     # TODO: scope with user_id
     conn =
       Task
       # |> where(user_id: ^user.id)
       |> Connection.from_query(&Repo.all/1, pagination_args)
     {:ok, conn}
  end

  def create(_parent, attributes, _info) do
    changeset = Task.changeset(%Task{type: "root"}, attributes)

    case Repo.insert(changeset) do
      {:ok, task} -> {:ok, %{task: task}}
      {:error, changeset} ->
        errors = Enum.map(changeset.errors,
                          fn {k, {v, _}} -> %{message: "#{k} #{v}"} end)
        {:error, errors}
    end
  end

  def update(_parent, attributes, _info) do
    changeset = Task |> Repo.get!(attributes.id) |> Task.changeset(attributes)

    case Repo.update(changeset) do
      {:ok, task} -> {:ok, %{task: task}}
      {:error, changeset} ->
        errors = Enum.map(changeset.errors,
                          fn {k, {v, _}} -> %{message: "#{k} #{v}"} end)
        {:error, errors}
    end
  end

  def delete(_parent, attributes, _info) do
    task = Repo.get!(Task, attributes.id)
    Repo.delete(task)
    {:ok, %{id: task.id}}
  end
end
