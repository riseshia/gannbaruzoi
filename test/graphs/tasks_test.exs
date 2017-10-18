defmodule Gannbaruzoi.TasksTest do
  use Gannbaruzoi.GraphCase

  describe "query tasks" do
    document(
      """
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
      """
    )

    @tag login_as: "user@email.com"
    test "returns all tasks", %{document: document, user: user} do
      insert!(:task, %{user: user})
      result = execute_query(document, context: %{current_user: user})

      assert {:ok, %{data: %{"tasks" => %{"edges" => [%{"node" => task}]}}}} =
             result
      assert ~w(description estimatedSize id loggedSize logs parentId status type) ==
             Map.keys(task)
    end

    @tag login_as: "user@email.com"
    test "returns tasks which loggedSize is 0",
         %{document: document, user: user} do
      insert!(:task, %{user: user})
      result = execute_query(document, context: %{current_user: user})

      assert {:ok, %{data: %{"tasks" => %{"edges" => [%{"node" => task}]}}}} =
             result
      assert 0 == Map.get(task, "loggedSize")
    end

    @tag login_as: "user@email.com"
    test "returns tasks which loggedSize is 1",
         %{document: document, user: user} do
      inserted_task = insert!(:task, %{user: user})
      insert!(:log, %{task_id: inserted_task.id})
      result = execute_query(document, context: %{current_user: user})

      assert {:ok, %{data: %{"tasks" => %{"edges" => [%{"node" => task}]}}}} =
             result
      assert 1 == Map.get(task, "loggedSize")
    end

    @tag login_as: "user@email.com"
    test "returns tasks which loggedSize is still 0",
         %{document: document, user: user} do
      inserted_task = insert!(:task, %{user: user})
      log = insert!(:log, %{task_id: inserted_task.id})
      delete!(:log, log)
      result = execute_query(document, context: %{current_user: user})

      assert {:ok, %{data: %{"tasks" => %{"edges" => [%{"node" => task}]}}}} =
             result
      assert 0 == Map.get(task, "loggedSize")
    end
  end

  describe "mutation createTask" do
    document(
      """
      mutation(
        $clientMutationId: String!,
        $description: String!,
        $estimatedSize: Int!,
        $parentId: ID
      ) {
        createTask(input: {
          clientMutationId: $clientMutationId,
          description: $description,
          estimatedSize: $estimatedSize,
          parentId: $parentId
        }) {
          task {
            id
            description
            estimatedSize
            type
            parentId
            status
          }
        }
      }
      """
    )

    @tag login_as: "user@email.com"
    test "returns new task with valid args",
         %{document: document, user: user} do
      variables = %{
        "clientMutationId" => "1",
        "description" => "New todo",
        "estimatedSize" => 3
      }
      result = execute_query(document,
                             variables: variables,
                             context: %{current_user: user})

      assert {:ok, %{data: %{"createTask" => %{"task" => task}}}} = result
      assert ~w(description estimatedSize id parentId status type) ==
             Map.keys(task)
    end

    @tag login_as: "user@email.com"
    test "returns new subtask with valid args",
         %{document: document, user: user} do
      task = insert!(:task, %{user_id: user.id})
      variables = %{
        "clientMutationId" => "1",
        "description" => "New todo",
        "estimatedSize" => 3,
        "parentId" => task.id
      }
      result = execute_query(document,
                             variables: variables,
                             context: %{current_user: user})

      assert {:ok, %{data: %{"createTask" => %{"task" => task}}}} = result
      assert ~w(description estimatedSize id parentId status type) ==
             Map.keys(task)
    end

    @tag login_as: "user@email.com"
    test "fails to create with invalid args",
         %{document: document, user: user} do
      variables = %{
        "clientMutationId" => "1",
        "description" => "",
        "estimatedSize" => 5
      }
      result = execute_query(document,
                             variables: variables,
                             context: %{current_user: user})

      assert {:ok, %{errors: [%{
        locations: [%{column: 0, line: 7}],
        message: "In field \"createTask\": description can't be blank"
      }]}} = result
    end
  end

  describe "mutation updateTask" do
    document(
      """
      mutation(
        $clientMutationId: String!,
        $id: ID!,
        $description: String,
        $estimatedSize: Int
      ) {
        updateTask(input: {
          clientMutationId: $clientMutationId,
          id: $id,
          estimatedSize: $estimatedSize,
          description: $description
        }) {
          task {
            id
            description
            estimatedSize
            type
            parentId
            status
          }
        }
      }
      """
    )

    @tag login_as: "user@email.com"
    test "updates task with valid args", %{document: document, user: user} do
      task = insert!(:task, %{user: user})
      variables = %{
        "clientMutationId" => "1",
        "id" => task.id,
        "description" => "Updated Todo",
        "estimatedSize" => 2
      }
      result = execute_query(document,
                             variables: variables,
                             context: %{current_user: user})

      assert {:ok, %{data: %{"updateTask" => %{"task" => task}}}} = result
      assert ~w(description estimatedSize id parentId status type) ==
             Map.keys(task)
    end

    @tag login_as: "user@email.com"
    test "fails to update task with invalid args",
         %{document: document, user: user} do
      task = insert!(:task, %{user: user})
      variables = %{
        "clientMutationId" => "1",
        "id" => task.id,
        "description" => "",
        "estimatedSize" => 2
      }
      result = execute_query(document,
                             variables: variables,
                             context: %{current_user: user})

      assert {:ok, %{errors: [%{
        locations: [%{column: 0, line: 7}],
        message: "In field \"updateTask\": description can't be blank"
      }]}} = result
    end
  end

  describe "mutation deleteTask" do
    document(
      """
      mutation($clientMutationId: String!, $id: ID!) {
        deleteTask(input: {
          clientMutationId: $clientMutationId,
          id: $id
        }) {
          id
        }
      }
      """
    )

    @tag login_as: "user@email.com"
    test "deletes task with valid args", %{document: document, user: user} do
      task = insert!(:task, %{user: user})
      variables = %{"clientMutationId" => "1", "id" => task.id}
      result = execute_query(document,
                             variables: variables,
                             context: %{current_user: user})

      assert {:ok, %{data: %{"deleteTask" => %{"id" => actual_id}}}} = result
      assert to_string(task.id) == actual_id
    end

    @tag login_as: "user@email.com"
    test "fails to delete task with invalid args",
         %{document: document, user: user} do
      variables = %{"clientMutationId" => "1", "id" => nil}
      result = execute_query(document,
                             variables: variables,
                             context: %{current_user: user})

      assert {:ok, %{errors: errors}} = result
      assert 1 == length(errors)
    end
  end
end

