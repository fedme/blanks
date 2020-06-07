defmodule Blanks.ClozeTests.ClozeTest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cloze_tests" do
    field :content, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(cloze_test, attrs) do
    cloze_test
    |> cast(attrs, [:name, :content])
    |> validate_required([:name, :content])
  end
end
