defmodule Gannbaruzoi.TaskSubscriptionsTest do
  use GannbaruzoiWeb.GraphqlChannelCase

  setup tags do
    {:ok, _, socket} =
      tags[:user]
      |> build_socket()
      |> subscribe_and_join(Absinthe.Phoenix.Channel, "__absinthe__:control")
    Map.put(tags, :socket, socket)
  end

  describe "query tasks" do
    document("""
    query Tasks {
      tasks(first: 10) {
        edges {
          cursor
          node {
            id
            description
            estimatedSize
            type
            parentId
            status
            loggedSize
            logs {
              id
              taskId
            }
          }
        }
        pageInfo {
          hasNextPage
        }
      }
    }
    """)

    @tag login_as: "user@email.com"
    test "returns all tasks", %{socket: socket, document: document, user: user} do
      insert!(:task, %{user: user})
      ref = push(socket, "doc", %{"query" => document})

      assert_reply ref, :ok, reply

      assert %{data: %{"tasks" => %{"edges" => [%{"node" => task}]}}} = reply
      assert ~w(description estimatedSize id loggedSize logs parentId status type) ==
               Map.keys(task)
    end
  end
end
