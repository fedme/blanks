defmodule Blanks.Repo.Migrations.CreateClozeTestSubmissionsTables do
  use Ecto.Migration

  def change do
    create table(:cloze_test_submissions) do
      add :cloze_test_id, references(:cloze_tests), null: false
      timestamps()
    end

    create table(:cloze_test_submission_fillings) do
      add :submission_id, references(:cloze_test_submissions, on_delete: :delete_all), null: false
      add :blank_id, :string
      add :value, :string
    end

    create index("cloze_test_submission_fillings", [:blank_id])
  end
end
