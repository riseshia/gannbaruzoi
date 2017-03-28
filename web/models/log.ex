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

  @doc """
  Returns changeset of log with passed task_id
  """
  def with_task_id(task_id) do
    %__MODULE__{task_id: task_id} |> create_changeset()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end

  @doc """
  Builds a changeset for create, based on the `struct` and `params`.
  """
  def create_changeset(struct, params \\ %{}) do
    changeset(struct, params)
    |> prepare_changes(fn changeset ->
      assoc(changeset.data, :task)
      |> changeset.repo.update_all(inc: [logged_size: 1])
      changeset
    end)
  end

  @doc """
  Builds a changeset for delete, based on the `struct` and `params`.
  """
  def delete_changeset(struct) do
    changeset(struct)
    |> prepare_changes(fn changeset ->
      assoc(changeset.data, :task)
      |> changeset.repo.update_all(inc: [logged_size: -1])
      changeset
    end)
  end
end
