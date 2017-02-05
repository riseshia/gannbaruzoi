defmodule Gannbaruzoi.Types do
  @moduledoc """
  GraphQL Types
  """
  use Absinthe.Schema.Notation
  import Absinthe.Relay.Connection.Notation

  @desc "A task"
  object :task do
    field :id, non_null(:id)
    field :description, non_null(:string)
    field :estimated_size, non_null(:integer)
    field :type, non_null(:task_enum)
    field :parent_id, :id
    field :status, non_null(:boolean)
  end

  @desc "Connection of Tasks"
  connection node_type: :task

  @desc "Task type"
  enum :task_enum do
    value :branch, as: "branch", description: "Sub-task"
    value :root, as: "root", description: "Root-task"
  end

  @desc "A log"
  object :log do
    field :id, non_null(:integer)
    field :task_id, non_null(:integer)
  end

  @desc "An auth"
  object :auth do
    field :uid, non_null(:id)
    field :client, non_null(:string)
    field :access_token, non_null(:string)
  end
end
