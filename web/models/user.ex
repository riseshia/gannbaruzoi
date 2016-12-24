defmodule Gannbaruzoi.User do
  @moduledoc """
  User model
  """

  use Gannbaruzoi.Web, :model

  schema "users" do
    field :email, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:email])
    |> validate_required([:email])
  end
end
