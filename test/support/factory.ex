defmodule Gannbaruzoi.Factory do
  alias Gannbaruzoi.{Repo, User, Task, Log}

  def build(:user) do
    %User{email: "default@email.com"}
  end

  def build(:task) do
    %Task{description: "Default Todo", estimated_size: 1, type: "root"}
  end

  # Convenience API

  def build(:user, attributes) do
    :user |> build() |> User.changeset(attributes)
  end

  def build(:log, attributes) do
    Log.with_task_id(attributes.task_id)
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ %{}) do
    Repo.insert! build(factory_name, attributes)
  end

  def delete!(:log, model) do
    model
    |> Log.delete_changeset()
    |> Repo.delete!()
  end
end
