defmodule Gannbaruzoi.Repo.Migrations.AddLoggedSizeToTask do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :logged_size, :integer, default: 0, null: false
    end
  end
end
