defmodule Gannbaruzoi.LogResolver do
  import Absinthe.Resolution.Helpers

  @moduledoc """
  The resolvers of log
  """
  alias Gannbaruzoi.{Repo, Log}

  def all(task, _, _) do
    batch({__MODULE__, :by_task_ids}, task.id, fn batch_results ->
      {:ok, Map.get(batch_results, task.id, [])}
    end)
  end

  def count(task, _, _) do
    batch({__MODULE__, :count_by_task_ids}, task.id, fn batch_results ->
      {:ok, Map.get(batch_results, task.id, 0)}
    end)
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

  def by_task_ids(_, task_ids) do
    Log
    |> Log.by_task_ids(task_ids)
    |> Repo.all
    |> Enum.group_by(&(&1.task_id))
  end
end
