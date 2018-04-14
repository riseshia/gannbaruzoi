defmodule Gannbaruzoi.QueryHelper do
  @moduledoc """
  QueryHelper
  """

  alias Gannbaruzoi.Schema

  def execute_query(document, options \\ []) do
    Absinthe.run(document, Schema, options)
  end

  defmacro document(document) do
    quote do
      setup config do
        Map.put(config, :document, unquote(document))
      end
    end
  end
end
