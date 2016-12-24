defmodule Gannbaruzoi.User do
  @moduledoc """
  User model
  """

  use Gannbaruzoi.Web, :model
  alias Gannbaruzoi.User
  alias Gannbaruzoi.Repo

  schema "users" do
    field :email, :string

    timestamps()
  end

  @doc"""
  Find dummy user or create one
  """
  def find_or_create_dummy do
    if user = Repo.one(User)do
      user
    else
      %User{email: "dummy@email.com"}
      |> Repo.insert!
    end
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
