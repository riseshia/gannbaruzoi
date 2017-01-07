defmodule Gannbaruzoi.Factory do
  alias Gannbaruzoi.Repo

  def build(:user) do
    %Gannbaruzoi.User{email: "default@email.com"}
  end

  def build(:task) do
    %Gannbaruzoi.Task{
      description: "Default Todo",
      estimated_size: 1,
      type: "parent"
    }
  end

  def build(:log) do
    %Gannbaruzoi.Log{}
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    Repo.insert! build(factory_name, attributes)
  end
end
