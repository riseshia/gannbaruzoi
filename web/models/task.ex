defmodule Gannbaruzoi.Task do
  @moduledoc """
  Task model
  """

  use Gannbaruzoi.Web, :model
  alias Gannbaruzoi.Repo
  alias Gannbaruzoi.Task

  schema "tasks" do
    field :description, :string
    field :estimated_size, :integer
    field :logged_size, :integer, default: 0
    field :type, :string
    field :status, :boolean, default: false
    belongs_to :user, Gannbaruzoi.User
    belongs_to :parent, Gannbaruzoi.Task
    has_many :logs, Gannbaruzoi.Log

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:description, :estimated_size, :status, :parent_id, :user_id])
    |> put_type()
    |> validate_required([:description, :estimated_size, :type, :status])
    |> validate_parent_id()
  end

  defp put_type(changeset) do
    if Map.has_key?(changeset.changes, :parent_id) do
      put_change(changeset, :type, "branch")
    else
      put_change(changeset, :type, "root")
    end
  end

  defp validate_parent_id(changeset) do
    if Map.has_key?(changeset.changes, :user_id) do
      user_id = changeset.changes.user_id
      vpid = fn :parent_id, pid ->
        with p_task <- Repo.get(Task, pid),
             true <- p_task.user_id == user_id do
          []
        else
          false -> [parent_id: "should be yours"]
          nil -> [parent_id: "is not found"]
          _ -> raise "unhundled"
        end
      end

      validate_change(changeset, :parent_id, vpid)
    else
      changeset
    end
  end
end
