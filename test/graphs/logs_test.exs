defmodule Gannbaruzoi.LogsTest do
  use Gannbaruzoi.GraphCase

  describe "mutation createLog" do
    document(
      """
      mutation($clientMutationId: String!, $taskId: ID!) {
        createLog(input: {
          clientMutationId: $clientMutationId,
          taskId: $taskId
        }) {
          log {
            id
            task_id
          }
        }
      }
      """
    )

    @tag login_as: "user@email.com"
    test "returns new log with valid args", %{document: document, user: user} do
      task = insert!(:task, %{user: user})
      variables = %{"clientMutationId" => "1", "taskId" => task.id}
      result = execute_query(document, variables: variables)

      assert {:ok, %{data: %{"createLog" => %{"log" => log}}}} = result
      assert ~w(id task_id) == Map.keys(log)
    end

    @tag login_as: "user@email.com"
    test "fails to create with invalid args", %{document: document} do
      variables = %{"clientMutationId" => "1", "taskId" => nil}
      result = execute_query(document, variables: variables)

      assert {:ok, %{errors: errors}} = result
      assert 1 == length(errors)
    end
  end

  describe "mutation deleteLog" do
    document(
      """
      mutation($clientMutationId: String!, $taskId: ID!) {
        deleteLog(input: {
          clientMutationId: $clientMutationId,
          taskId: $taskId
        }) {
          id
        }
      }
      """
    )

    @tag login_as: "user@email.com"
    test "deletes log with valid args", %{document: document, user: user} do
      task = insert!(:task, %{user: user})
      log = insert!(:log, %{task_id: task.id})

      variables = %{"clientMutationId" => "1", "taskId" => log.task_id}
      result = execute_query(document, variables: variables)
      assert {:ok, %{data: %{"deleteLog" => %{"id" => actual_id}}}} = result
      assert to_string(log.id) == actual_id
    end

    @tag login_as: "user@email.com"
    test "fails to delete log with invalid args", %{document: document} do
      variables = %{"clientMutationId" => "1", "taskId" => nil}
      result = execute_query(document, variables: variables)
      assert {:ok, %{errors: errors}} = result
      assert 1 == length(errors)
    end
  end
end

