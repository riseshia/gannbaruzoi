defmodule Gannbaruzoi.Context do
  @behaviour Plug

  import Plug.Conn

  alias Gannbaruzoi.{Repo, User}

  def init(opts), do: opts

  def call(conn, _) do
    case build_context(conn) do
      {:ok, context} ->
        put_private(conn, :absinthe, %{context: context})

      {:error, reason} ->
        conn
        |> send_resp(403, reason)
        |> halt()

      _ ->
        conn
        |> send_resp(400, "Bad Request")
        |> halt()
    end
  end

  @doc """
  Return the current user context based on the authorization header
  """
  def build_context(conn) do
    with [uid] <- get_req_header(conn, "uid"),
         [client] <- get_req_header(conn, "client"),
         [access_token] <- get_req_header(conn, "access-token"),
         current_user <- Repo.get_by(User, email: uid),
         true <- current_user && User.valid_token?(current_user, client, access_token) do
      {:ok, %{current_user: current_user}}
    else
      [] -> {:ok, %{}}
      _ -> {:error, "Invalid Auth"}
    end
  end
end
