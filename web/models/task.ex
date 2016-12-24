defmodule Gannbaruzoi.Task do
  use Gannbaruzoi.Web, :model
  @moduledoc """
  Task model
  """

  schema "tasks" do
    field :description, :string
    field :estimated_size, :integer
    field :type, :string
    field :status, :boolean, default: false
    belongs_to :user, Gannbaruzoi.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :estimated_size, :type, :status])
    |> validate_required([:description, :estimated_size, :type, :status])
  end
end
