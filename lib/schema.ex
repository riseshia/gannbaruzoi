defmodule Gannbaruzoi.Schema do
  @moduledoc """
  Graphql schema
  """

  use Absinthe.Schema
  use Absinthe.Relay.Schema

  alias Gannbaruzoi.LogResolver
  alias Gannbaruzoi.TaskResolver

  import_types Gannbaruzoi.Types

  query do
    @desc "Get all tasks of current user"
    field :tasks, list_of(:task) do
      resolve &TaskResolver.all/2
    end
  end

  mutation do
    @desc "Create new task"
    payload field :create_task do
      input do
        field :estimated_size, non_null(:integer)
        field :description, non_null(:string)
        field :root_flg, non_null(:boolean)
      end
      output do
        field :task, :task
      end
      resolve &TaskResolver.create/3
    end

    @desc "Update the task"
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
      resolve &TaskResolver.update/3
    end

    @desc "Delete the task"
    payload field :delete_task do
      input do
        field :id, non_null(:id)
      end
      output do
        field :id, :id
      end
      resolve &TaskResolver.delete/3
    end

    @desc "Create a log to specific task"
    payload field :create_log do
      input do
        field :task_id, non_null(:id)
      end
      output do
        field :log, :log
      end
      resolve &LogResolver.create/2
    end

    @desc "Delete a log from specific task"
    payload field :delete_log do
      input do
        field :task_id, non_null(:id)
      end
      output do
        field :id, :id
      end
      resolve &LogResolver.delete/2
    end
  end
end
