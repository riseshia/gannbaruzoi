defmodule Gannbaruzoi.Factory do
  alias Gannbaruzoi.{Repo, User, Task, Log}

  def build(:user) do
    %User{email: "default@email.com"}
  end

  def build(:task) do
    %Task{description: "Default Todo", estimated_size: 1, type: "root"}
  end

  def build(:log) do
    %Log{}
  end

  # Convenience API

  def build(:user, attributes) do
    :user |> build() |> User.changeset(attributes)
  end

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ %{}) do
    Repo.insert! build(factory_name, attributes)
  end

  def delete!(model) do
    Repo.delete!(model)
  end
end
