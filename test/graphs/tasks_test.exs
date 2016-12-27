defmodule Gannbaruzoi.TasksTest do
  use Gannbaruzoi.ModelCase

  test "find_or_create_dummy with no registed user" do
    response =
      """
      query Tasks {
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
    assert {:ok, %{data: %{"tasks" => []}}} == response
  end
end

