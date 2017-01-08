defmodule Gannbaruzoi.User do
  @moduledoc """
  User model
  """

  use Gannbaruzoi.Web, :model
  alias Gannbaruzoi.User
  alias Gannbaruzoi.Repo

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true
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

  def build_session(user) do
    token = random_string(40)
    client = random_string(40)

    auth = %{uid: user.email, token: token, client: client}

    tokens = Map.get(user, :tokens) || %{}
    now = DateTime.utc_now() |> DateTime.to_unix()
    expiry = now + 60 * 60 * 24 * 14

    new_tokens =
      Map.put(tokens, client, %{
        token: Comeonin.Bcrypt.hashpwsalt(token),
        expiry: expiry
      })

    cast(user, %{tokens: new_tokens, auth: auth}, [:tokens, :auth])
  end

  def delete_session(user, client) do
    tokens = Map.delete(user.tokens, client)
    cast(user, %{tokens: tokens}, [:tokens])
  end

  def valid_token?(user, client, token,
                   now \\ DateTime.utc_now() |> DateTime.to_unix()) do
    tokens = user.tokens[client]
    tokens && Comeonin.Bcrypt.checkpw(token, tokens["token"]) &&
      now < tokens["expiry"]
  end

  def match_password?(user, password) do
    Comeonin.Bcrypt.checkpw(password, user.encrypted_password)
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
    |> cast(params, [:password])
    |> validate_length(:password, min: 6, max: 100)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
         put_change(changeset, :encrypted_password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
         changeset
    end
  end
end
