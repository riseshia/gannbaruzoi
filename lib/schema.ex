defmodule Gannbaruzoi.Schema do
  @moduledoc """
  Graphql schema
  """

  use Absinthe.Schema
  use Absinthe.Relay.Schema

  @tasks [
    %{id: 1, description: "Todo 1", estimated_size: 1,
      type: "parent", status: false},
    %{id: 2, description: "Todo 2", estimated_size: 2,
      type: "parent", status: false},
    %{id: 3, description: "Todo 3", estimated_size: 3,
      type: "parent", status: false},
    %{id: 4, description: "Todo 4", estimated_size: 4,
      type: "parent", status: false}
  ]

  @logs [
    %{id: 1, task_id: 1},
    %{id: 2, task_id: 1},
    %{id: 3, task_id: 3},
    %{id: 4, task_id: 2}
  ]

  object :task do
    field :id, :id
    field :description, :string
    field :estimated_size, :integer
    field :type, :string
    field :status, :boolean
  end

  object :log do
    field :id, :id
    field :task_id, :id
  end

  query do
    field :tasks, list_of(:task) do
      resolve fn _, _ ->
        {:ok, @tasks}
      end
    end
  end

  mutation do
    payload field :create_task do
      input do
        field :estimated_size, non_null(:integer)
        field :description, non_null(:string)
        field :root_flg, non_null(:boolean)
      end
      output do
        field :task, :task
      end
      resolve fn _, _ ->
        {:ok, %{task: List.first(@tasks)}}
      end
    end

    payload field :update_task do
      input do
        field :estimated_size, :integer
        field :description, :string
        field :root_flg, :boolean
        field :done_flg, :boolean
      end
      output do
        field :task, :task
      end
      resolve fn _, _ ->
        {:ok, %{task: List.first(@tasks)}}
      end
    end

    payload field :delete_task do
      input do
        field :id, non_null(:id)
      end
      output do
        field :id, :id
      end
      resolve fn _, _ ->
        {:ok, %{id: 1}}
      end
    end

    payload field :create_log do
      input do
        field :task_id, non_null(:id)
      end
      output do
        field :log, :log
      end
      resolve fn _, _ ->
        {:ok, %{log: List.first(@logs)}}
      end
    end

    payload field :delete_log do
      input do
        field :task_id, non_null(:id)
      end
      output do
        field :id, :id
      end
      resolve fn _, _ ->
        {:ok, %{id: 1}}
      end
    end
  end
end
