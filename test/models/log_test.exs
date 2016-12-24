defmodule Gannbaruzoi.LogTest do
  use Gannbaruzoi.ModelCase

  alias Gannbaruzoi.Log

  @valid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Log.changeset(%Log{}, @valid_attrs)
    assert changeset.valid?
  end
end
