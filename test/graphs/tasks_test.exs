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
              estimated_size
              type
              parent_id
              status
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
      insert!(:task, user: user)
      result = execute_query(document, context: %{current_user: user})

      assert {:ok, %{data: %{"tasks" => %{"edges" => [%{"node" => task}]}}}} =
             result
      assert ~w(description estimated_size id parent_id status type) ==
             Map.keys(task)
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
            estimated_size
            type
            parent_id
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
      assert ~w(description estimated_size id parent_id status type) ==
             Map.keys(task)
    end

    @tag login_as: "user@email.com"
    test "returns new subtask with valid args",
         %{document: document, user: user} do
      task = insert!(:task, user_id: user.id)
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
      assert ~w(description estimated_size id parent_id status type) ==
             Map.keys(task)
    end

    @tag login_as: "user@email.com"
    test "fails to create with invalid args",
         %{document: document, user: user} do
      variables = %{
        "clientMutationId" => "1",
        "description" => nil
      }
      result = execute_query(document,
                             variables: variables,
                             context: %{current_user: user})

      assert {:ok, %{errors: errors}} = result
      assert 1 == length(errors)
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
            estimated_size
            type
            parent_id
            status
          }
        }
      }
      """
    )

    @tag login_as: "user@email.com"
    test "updates task with valid args", %{document: document, user: user} do
      task = insert!(:task, user: user)
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
      assert ~w(description estimated_size id parent_id status type) ==
             Map.keys(task)
    end

    @tag login_as: "user@email.com"
    test "fails to update task with invalid args",
         %{document: document, user: user} do
      variables = %{
        "clientMutationId" => "1",
        "id" => nil,
        "description" => "Updated Todo",
        "estimatedSize" => 2
      }
      result = execute_query(document,
                             variables: variables,
                             context: %{current_user: user})

      assert {:ok, %{errors: errors}} = result
      assert 1 == length(errors)
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
      task = insert!(:task, user: user)
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

