defmodule Gannbaruzoi.Log do
  @moduledoc """
  Log model
  """

  use Gannbaruzoi.Web, :model

  alias Gannbaruzoi.Task

  schema "logs" do
    belongs_to :task, Task

    timestamps()
  end

  def by_task_id(query, task_id) do
    where(query, ^[task_id: task_id])
  end

  def by_task_ids(query, task_ids) do
    where(query, [m], m.task_id in ^task_ids)
  end

  def recent(query \\ __MODULE__) do
    order_by(query, ^[desc: :inserted_at])
  end

  def count_by_task_ids(query, task_ids) do
    from(l in __MODULE__, group_by: l.task_id, select: {l.task_id, count(l.id)})
    |> by_task_ids(task_ids)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
