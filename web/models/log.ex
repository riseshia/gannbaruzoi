defmodule Gannbaruzoi.Log do
  @moduledoc """
  Log model
  """

  use Gannbaruzoi.Web, :model

  alias Gannbaruzoi.Repo
  alias Gannbaruzoi.Task

  schema "logs" do
    belongs_to :task, Gannbaruzoi.Task

    timestamps()
  end

  def first_of(task_id) do
    task = Repo.get Task, task_id
    Ecto.assoc(task, :logs)
    |> first
    |> Repo.one
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
