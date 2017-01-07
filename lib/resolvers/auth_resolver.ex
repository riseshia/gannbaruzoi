defmodule Gannbaruzoi.AuthResolver do
  @moduledoc """
  The resolvers of auth
  """
  alias Gannbaruzoi.Repo
  alias Gannbaruzoi.User

  def create(input, _info) do
    user = Repo.get_by(User, email: input.email)
    if User.match_password?(user, input.password) do
      case Repo.update(User.build_session(user)) do
        {:ok, user} -> {:ok, %{auth: user.auth}}
        {:error, changeset} -> {:error, changeset.errors}
      end
    else
      {:error, "fail to login"}
    end
  end

  def delete(%{client: client}, info) do
    user = User.delete_session(info.current_user, client)
    case Repo.update(user) do
      {:ok, _} -> {:ok, %{result: "ok"}}
      {:error, changeset} -> {:error, changeset.errors}
    end
  end
end
