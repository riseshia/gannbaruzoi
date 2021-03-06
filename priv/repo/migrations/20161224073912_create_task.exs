defmodule Gannbaruzoi.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :description, :string
      add :estimated_size, :integer
      add :type, :string
      add :status, :boolean, default: false, null: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:tasks, [:user_id])

  end
end
