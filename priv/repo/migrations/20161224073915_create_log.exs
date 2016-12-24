defmodule Gannbaruzoi.Repo.Migrations.CreateLog do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :task_id, references(:tasks, on_delete: :nothing)

      timestamps()
    end
    create index(:logs, [:task_id])

  end
end
