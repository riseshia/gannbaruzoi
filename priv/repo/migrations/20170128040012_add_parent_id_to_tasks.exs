defmodule Gannbaruzoi.Repo.Migrations.AddParentIdToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :parent_id, references(:tasks, on_delete: :nothing)
    end
  end
end
