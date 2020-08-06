defmodule Blanks.ClozeTests.ClozeTestSubmissionFilling do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cloze_test_submission_fillings" do
    belongs_to :submission, Blanks.ClozeTests.ClozeTestSubmission
    field :blank_id, :string
    field :value, :string
  end

  @doc false
  def changeset(filling, attrs) do
    filling
    |> cast(attrs, [:blank_id, :value])
    |> validate_required([:blank_id, :value])
  end
end
