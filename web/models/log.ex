defmodule Gannbaruzoi.Log do
  use Gannbaruzoi.Web, :model
  @moduledoc """
  Log model
  """

  schema "logs" do
    belongs_to :task, Gannbaruzoi.Task

    timestamps()
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
