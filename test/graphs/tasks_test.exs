defmodule Gannbaruzoi.TasksTest do
  use Gannbaruzoi.GraphCase

  def task_with_user! do
    user = insert!(:user)
    insert!(:task, user: user)
  end

  describe "query tasks" do
    document(
      """
      {
        tasks {
          id
          description
          estimated_size
          type
          status
        }
      }
      """
    )

    test "returns all tasks", %{document: document} do
      task_with_user!()
      result = execute_query(document)

      assert {:ok, %{data: %{"tasks" => [task]}}} = result
      assert ~w(description estimated_size id status type) == Map.keys(task)
    end
  end

  describe "mutation createTask" do
    document(
      """
      mutation(
        $clientMutationId: String!,
        $description: String!,
        $estimatedSize: Int!,
        $rootFlg: Boolean!
      ) {
        createTask(input: {
          clientMutationId: $clientMutationId,
          description: $description,
          estimatedSize: $estimatedSize,
          rootFlg: $rootFlg
        }) {
          task {
            id
            description
            estimated_size
            type
            status
          }
        }
      }
      """
    )

    test "returns new task with valid args", %{document: document} do
      variables = %{
        "clientMutationId" => "1",
        "description" => "New todo",
        "estimatedSize" => 3,
        "rootFlg" => true
      }
      result = execute_query(document, variables: variables)

      assert {:ok, %{data: %{"createTask" => %{"task" => task}}}} = result
      assert ~w(description estimated_size id status type) == Map.keys(task)
    end

    test "fails to create with invalid args", %{document: document} do
      variables = %{
        "clientMutationId" => "1",
        "description" => nil,
        "estimatedSize" => 3,
        "rootFlg" => true
      }
      result = execute_query(document, variables: variables)

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
        $estimatedSize: Int,
        $rootFlg: Boolean
      ) {
        updateTask(input: {
          clientMutationId: $clientMutationId,
          id: $id,
          estimatedSize: $estimatedSize,
          description: $description,
          rootFlg: $rootFlg
        }) {
          task {
            id
            description
            estimated_size
            type
            status
          }
        }
      }
      """
    )
    test "updates task with valid args", %{document: document} do
      task = task_with_user!()
      variables = %{
        "clientMutationId" => "1",
        "id" => task.id,
        "description" => "Updated Todo",
        "estimatedSize" => 2,
        "rootFlg" => true
      }
      result = execute_query(document, variables: variables)

      assert {:ok, %{data: %{"updateTask" => %{"task" => task}}}} = result
      assert ~w(description estimated_size id status type) == Map.keys(task)
    end

    test "fails to update task with invalid args", %{document: document} do
      variables = %{
        "clientMutationId" => "1",
        "id" => nil,
        "description" => "Updated Todo",
        "estimatedSize" => 2,
        "rootFlg" => true
      }
      result = execute_query(document, variables: variables)

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
    test "deletes task with valid args", %{document: document} do
      task = task_with_user!()
      variables = %{"clientMutationId" => "1", "id" => task.id}
      result = execute_query(document, variables: variables)

      assert {:ok, %{data: %{"deleteTask" => %{"id" => actual_id}}}} = result
      assert to_string(task.id) == actual_id
    end

    test "fails to delete task with invalid args", %{document: document} do
      variables = %{"clientMutationId" => "1", "id" => nil}
      result = execute_query(document, variables: variables)

      assert {:ok, %{errors: errors}} = result
      assert 1 == length(errors)
    end
  end
end

