defmodule Gannbaruzoi.Types do
  @moduledoc """
  GraphQL Types
  """
  use Absinthe.Schema.Notation
  import Absinthe.Relay.Connection.Notation

  @desc "A task"
  object :task do
    field :id, :id
    field :description, :string
    field :estimated_size, :integer
    field :type, :string
    field :parent_id, :id
    field :status, :boolean
  end

  @desc "Connection of Tasks"
  connection node_type: :task

  @desc "A log"
  object :log do
    field :id, :id
    field :task_id, :id
  end

  @desc "An auth"
  object :auth do
    field :uid, :string
    field :client, :string
    field :access_token, :string
  end
end
