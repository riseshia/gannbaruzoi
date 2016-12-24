defmodule Gannbaruzoi.Log do
  @moduledoc """
  Log model
  """

  use Gannbaruzoi.Web, :model

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
