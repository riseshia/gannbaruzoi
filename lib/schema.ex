defmodule Gannbaruzoi.Schema do
  @moduledoc """
  Graphql schema
  """

  use Absinthe.Schema
  use Absinthe.Relay.Schema
  alias Gannbaruzoi.Task
  alias Gannbaruzoi.Log
  alias Gannbaruzoi.Repo

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
        tasks = Repo.all(Task)
        {:ok, tasks}
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
      resolve fn _parent, attributes, _info ->
        IO.inspect attributes
        changeset = Task.changeset(%Task{type: "root"}, attributes)
        case Repo.insert(changeset) do
          {:ok, task} -> {:ok, %{task: task}}
          {:error, changeset} -> {:error, changeset.errors}
        end
      end
    end

    payload field :update_task do
      input do
        field :id, non_null(:id)
        field :estimated_size, :integer
        field :description, :string
        field :root_flg, :boolean
        field :done_flg, :boolean
      end
      output do
        field :task, :task
      end
      resolve fn _parent, attributes, _info ->
        IO.inspect attributes
        changeset = Repo.get!(Task, attributes.id) |> Task.changeset(attributes)
        case Repo.update(changeset) do
          {:ok, task} -> {:ok, %{task: task}}
          {:error, changeset} -> {:error, changeset.errors}
        end
      end
    end

    payload field :delete_task do
      input do
        field :id, non_null(:id)
      end
      output do
        field :id, :id
      end
      resolve fn _parent, attributes, _info ->
        IO.inspect attributes
        task = Repo.get!(Task, attributes.id)
        Repo.delete(task)
        {:ok, %{id: task.id}}
      end
    end

    payload field :create_log do
      input do
        field :task_id, non_null(:id)
      end
      output do
        field :log, :log
      end
      resolve fn %{task_id: task_id}, _ ->
        log = %Log{task_id: task_id} |> Repo.insert!
        {:ok, %{log: log}}
      end
    end

    payload field :delete_log do
      input do
        field :task_id, non_null(:id)
      end
      output do
        field :id, :id
      end
      resolve fn %{task_id: task_id}, _ ->
        log = Log.first_of(task_id)
        log |> Repo.delete
        {:ok, %{id: log.id}}
      end
    end
  end
end
