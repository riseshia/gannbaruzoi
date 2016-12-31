defmodule Gannbaruzoi.TasksTest do
  use Gannbaruzoi.ModelCase

  def task_with_user! do
    user = insert!(:user)
    insert!(:task, user: user)
  end

  describe "query Tasks" do
    test "query tasks returns all task" do
      task_with_user!
      {:ok, %{data: %{"tasks" => [task]}}} =
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
        |> Absinthe.run(Gannbaruzoi.Schema)
      expected_keys = ~w/description estimated_size id status type/
      assert expected_keys == Map.keys(task)
    end
  end

  describe "mutation CreateTask" do
    test "returns new task" do
      {:ok, %{data: %{"createTask" => %{"task" => task}}}} =
        """
        mutation {
          createTask(input: {
            clientMutationId: "1",
            estimatedSize: 1,
            description: "New Todo",
            rootFlg: true
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
        |> Absinthe.run(Gannbaruzoi.Schema)
      expected_keys = ~w/description estimated_size id status type/
      assert expected_keys == Map.keys(task)
    end

    test "fail to create as invalid args" do
      {:ok, %{errors: errors}} =
        """
        mutation {
          createTask(input: {
            clientMutationId: "1",
            estimatedSize: 1,
            # description: "New Todo", <- Required
            rootFlg: true
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
        |> Absinthe.run(Gannbaruzoi.Schema)
      assert 1 == length(errors)
    end
  end

  describe "mutation Update Task" do
    test "updates task" do
      task = task_with_user!
      
      {:ok, %{data: %{"updateTask" => %{"task" => task}}}} =
        """
        mutation {
          updateTask(input: {
            id: #{task.id},
            clientMutationId: "2",
            estimatedSize: 2,
            description: "Updated Todo",
            rootFlg: true
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
        |> Absinthe.run(Gannbaruzoi.Schema)
      expected_keys = ~w/description estimated_size id status type/
      assert expected_keys == Map.keys(task)
    end

    test "fails to update task" do
      {:ok, %{errors: errors}} =
        """
        mutation {
          updateTask(input: {
            clientMutationId: "1",
            # id: some_id, <- Required
            estimatedSize: 1,
            rootFlg: true
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
        |> Absinthe.run(Gannbaruzoi.Schema)
      assert 1 == length(errors)
    end
  end

  describe "mutation Delete Task" do
    test "deletes task" do
      task = task_with_user!

      {:ok, %{data: %{"deleteTask" => %{"id" => actual_id}}}} =
        """
        mutation {
          deleteTask(input: {
            clientMutationId: "1",
            id: #{task.id}
          }) {
            id
          }
        }
        """
        |> Absinthe.run(Gannbaruzoi.Schema)
      assert to_string(task.id) == actual_id 
    end

    test "fails to delete task" do
      {:ok, %{errors: errors}} =
        """
        mutation {
          deleteTask(input: {
            clientMutationId: "1"
            # id: some_id <- Required
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

