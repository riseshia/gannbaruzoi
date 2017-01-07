defmodule Gannbaruzoi.Repo.Migrations.AddPasswordToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :encrypted_password, :string
      add :tokens, :map
    end
  end
end
