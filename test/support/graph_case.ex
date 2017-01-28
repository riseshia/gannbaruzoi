defmodule Gannbaruzoi.GraphCase do
  @moduledoc """
  This module defines the test case to be used by
  graph tests.

  You may define functions here to be used as helpers in
  your graph tests. See `errors_on/2`'s definition as reference.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Gannbaruzoi.ModelCase
      import Gannbaruzoi.Factory
      import Gannbaruzoi.QueryHelper
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Gannbaruzoi.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Gannbaruzoi.Repo, {:shared, self()})
    end

    :ok
  end

  setup config do
    if email = config[:login_as] do
      user = Gannbaruzoi.Repo.insert!(%Gannbaruzoi.User{email: email})
      Map.put(config, :user, user)
    else
      config
    end
  end
end

