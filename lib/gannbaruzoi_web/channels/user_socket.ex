defmodule GannbaruzoiWeb.UserSocket do
  use Phoenix.Socket
  use Absinthe.Phoenix.Socket, schema: Gannbaruzoi.Schema

  alias Gannbaruzoi.User

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket

  def connect(params, socket) do
    with current_user <- fetch_user(params),
         true <- current_user && has_valid_token?(current_user, params) do
      socket = Absinthe.Phoenix.Socket.put_options(socket, context: %{
        current_user: current_user
      })
      {:ok, socket}
    else
      _ -> {:error, %{reason: "Unauthorized"}}
    end
  end

  defp fetch_user(%{"user_id" => id}) do
    Gannbaruzoi.Repo.get(User, id)
  end

  defp has_valid_token?(user, %{"client" => client, "access_token" => access_token}) do
    User.valid_token?(user, client, access_token)
  end

  # Socket id's are topics that allow you to identify all sockets
  # for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     GannbaruzoiWeb.Endpoint.broadcast(
  #       "users_socket:#{user.id}", "disconnect", %{}
  #     )
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
