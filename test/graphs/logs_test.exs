defmodule Gannbaruzoi.LogsTest do
  use Gannbaruzoi.ModelCase

  def task! do
    user = insert!(:user)
    insert!(:task, user: user)
  end

  def log! do
    insert!(:log, task_id: task!.id)
  end

  describe "mutation createLog" do
    test "returns new log with valid args" do
      {:ok, %{data: %{"createLog" => %{"log" => log}}}} =
        """
        mutation {
          createLog(input: {
            clientMutationId: "1",
            taskId: #{task!.id}
          }) {
            log {
              id
              task_id
            }
          }
        }
        """
        |> Absinthe.run(Gannbaruzoi.Schema)
      expected_keys = ~w(id task_id)
      assert expected_keys == Map.keys(log)
    end

    test "fails to create with invalid args" do
      {:ok, %{errors: errors}} =
        """
        mutation {
          createLog(input: {
            clientMutationId: "1"
            # taskId: some_id <- Required
          }) {
            log {
              id
              task_id
            }
          }
        }
        """
        |> Absinthe.run(Gannbaruzoi.Schema)
      assert 1 == length(errors)
    end
  end

  describe "mutation deleteLog" do
    test "deletes log with valid args" do
      log = log!
      {:ok, %{data: %{"deleteLog" => %{"id" => actual_id}}}} =
        """
        mutation {
          deleteLog(input: {
            clientMutationId: "1",
            taskId: #{log.task_id}
          }) {
            id
          }
        }
        """
        |> Absinthe.run(Gannbaruzoi.Schema)
      assert to_string(log.id) == actual_id
    end

    test "fails to delete log with invalid args" do
      {:ok, %{errors: errors}} =
        """
        mutation {
          deleteLog(input: {
            clientMutationId: "1"
            # taskId: some_id <- Required
          }) {
            id
          }
        }
        """
        |> Absinthe.run(Gannbaruzoi.Schema)
      assert 1 == length(errors)
    end
  end
end
