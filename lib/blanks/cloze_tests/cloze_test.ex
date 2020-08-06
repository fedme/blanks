defmodule Blanks.ClozeTests.ClozeTest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cloze_tests" do
    field :content, :string
    field :name, :string
    belongs_to :user, Blanks.Accounts.User
    has_many :submissions, Blanks.ClozeTests.ClozeTestSubmission
    timestamps()
  end

  @doc false
  def changeset(cloze_test, attrs) do
    cloze_test
    |> cast(attrs, [:name, :content, :user_id])
    |> validate_required([:name, :content, :user_id])
  end
end
