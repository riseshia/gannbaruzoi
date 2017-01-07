defmodule Gannbaruzoi.User do
  @moduledoc """
  User model
  """

  use Gannbaruzoi.Web, :model
  alias Gannbaruzoi.User
  alias Gannbaruzoi.Repo
  alias Gannbaruzoi.Auth

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :encrypted_password, :string
    field :tokens, :map
    field :auth, :map, virtual: true, default: %{}

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

  def create_session(user) do
    token = random_string(40)
    client = random_string(40)

    auth = %{uid: user.email, token: token, client: client}

    tokens = Map.get(user, :tokens) || %{}
    new_tokens =
      Map.put(tokens, client, %{
        token: token,
        expiry: 1111
      })

    cast(user, %{tokens: new_tokens, auth: auth }, [:tokens, :auth])
  end

  def delete_session(user, client) do
    tokens = Map.delete(user.tokens, client)
    cast(user, %{tokens: tokens}, [:tokens])
  end

  def match_password?(user, password) do
    true
  end

  defp random_string(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:email])
    |> validate_required([:email])
  end
end
