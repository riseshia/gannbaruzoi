defmodule Gannbaruzoi.QueryHelper do
  def execute_query(document, options \\ []) do
    Absinthe.run(document, Gannbaruzoi.Schema, options)
  end

  defmacro document(document) do
    quote do
      setup config do
        Map.put(config, :document, unquote(document))
      end
    end
  end
end
