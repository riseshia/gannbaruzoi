defmodule Gannbaruzoi.AuthResolver do
  @moduledoc """
  The resolvers of auth
  """
  alias Gannbaruzoi.{Repo, User}

  def create(input, _info) do
    user = Repo.get_by(User, email: input.email)

    if user && User.match_password?(user, input.password) do
      case Repo.update(User.build_session(user)) do
        {:ok, user} -> {:ok, %{auth: user.auth}}
        {:error, changeset} -> {:error, changeset.errors}
      end
    else
      {:error, "fail to login"}
    end
  end

  def delete(%{client: client}, info) do
    with true <-
           Map.has_key?(info.context, :current_user) &&
             Map.has_key?(info.context.current_user.tokens, client),
         user <- User.delete_session(info.context.current_user, client),
         {:ok, _} <- Repo.update(user) do
      {:ok, %{result: "ok"}}
    else
      _ -> {:error, "fail to logout"}
    end
  end
end
