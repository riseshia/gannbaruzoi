defmodule Gannbaruzoi.Factory do
  @moduledoc """
  Factory
  """

  alias Gannbaruzoi.{Repo, User, Task, Log}

  # Convenience API
  def build(factory_name, attributes \\ %{})

  def build(:user, attributes) do
    %User{email: "default@email.com"} |> User.changeset(attributes)
  end

  def build(:log, attributes) do
    %Log{task_id: attributes.task_id} |> Log.create_changeset()
  end

  def build(:task, attributes) do
    %Task{description: "Default Todo", estimated_size: 1, type: "root"}
    |> Task.changeset(attributes)
  end

  def insert!(factory_name, attributes \\ %{}) do
    Repo.insert!(build(factory_name, attributes))
  end

  def delete!(:log, model) do
    model
    |> Log.delete_changeset()
    |> Repo.delete!()
  end
end
