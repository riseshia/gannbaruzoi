defmodule Gannbaruzoi.Types do
  @moduledoc """
  GraphQL Types
  """
  use Absinthe.Schema.Notation

  @desc "A task"
  object :task do
    field :id, :id
    field :description, :string
    field :estimated_size, :integer
    field :type, :string
    field :status, :boolean
  end

  @desc "A log"
  object :log do
    field :id, :id
    field :task_id, :id
  end
end
