defmodule Blanks.ClozeTests.ClozeTestSubmission do
  use Ecto.Schema
  import Ecto.Changeset

  schema "cloze_test_submissions" do
    belongs_to :cloze_test, Blanks.ClozeTests.ClozeTest
    has_many :fillings, Blanks.ClozeTests.ClozeTestSubmissionFilling, foreign_key: :submission_id
    timestamps()
  end

  @doc false
  def changeset(submission, attrs) do
    submission
    |> cast(attrs, [:cloze_test_id])
    |> cast_assoc(:fillings, with: &Blanks.ClozeTests.ClozeTestSubmissionFilling.changeset/2)
    |> validate_required([:cloze_test_id])
  end
end
