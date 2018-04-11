defmodule Gannbaruzoi.Types do
  @moduledoc """
  GraphQL Types
  """
  use Absinthe.Schema.Notation
  import Absinthe.Relay.Connection.Notation

  alias Gannbaruzoi.LogResolver

  @desc "A task"
  object :task do
    field(:id, non_null(:id))
    field(:description, non_null(:string))
    field(:estimated_size, non_null(:integer))
    field(:type, non_null(:task_enum))
    field(:parent_id, :id)
    field(:status, non_null(:boolean))
    field(:logged_size, non_null(:integer))

    field :logs, non_null(list_of(non_null(:log))) do
      resolve(&LogResolver.all/3)
    end
  end

  @desc "Connection of Tasks"
  connection(node_type: :task)

  @desc "Task type"
  enum :task_enum do
    value(:branch, as: "branch", description: "Sub-task")
    value(:root, as: "root", description: "Root-task")
  end

  @desc "A log"
  object :log do
    field(:id, non_null(:integer))
    field(:task_id, non_null(:integer))
  end

  @desc "An auth"
  object :auth do
    field(:uid, non_null(:id))
    field(:client, non_null(:string))
    field(:access_token, non_null(:string))
  end
end
