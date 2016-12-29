defmodule Gannbaruzoi.LogResolver do
  @moduledoc """
  The resolvers of log
  """
  alias Gannbaruzoi.Repo
  alias Gannbaruzoi.Log

  def create(%{task_id: task_id}, _info) do
    log =
      %Log{task_id: String.to_integer(task_id)}
      |> Log.changeset
      |> Repo.insert!
    {:ok, %{log: log}}
  end

  def delete(%{task_id: task_id}, _info) do
    log = Log.first_of(task_id)
    Repo.delete(log)
    {:ok, %{id: log.id}}
  end
end
