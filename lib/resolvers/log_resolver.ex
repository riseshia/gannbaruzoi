defmodule Gannbaruzoi.LogResolver do
  @moduledoc """
  The resolvers of log
  """
  alias Gannbaruzoi.{Repo, Log}

  def all(task, _, _) do
     logs =
      task
      |> Ecto.assoc(:logs)
      |> Repo.all
     {:ok, logs}
  end

  def create(%{task_id: task_id}, _info) do
    log =
      %Log{task_id: String.to_integer(task_id)}
      |> Log.changeset()
      |> Repo.insert!()
    {:ok, %{log: log}}
  end

  def delete(%{task_id: task_id}, _info) do
    log = Log |> Log.by_task_id(task_id) |> Log.recent() |> Repo.one()
    Repo.delete(log)
    {:ok, %{id: log.id}}
  end
end
