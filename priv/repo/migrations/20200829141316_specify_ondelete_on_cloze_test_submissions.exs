defmodule Blanks.Repo.Migrations.SpecifyOndeleteOnClozeTestSubmissions do
  use Ecto.Migration

  def up do
    drop(constraint(:cloze_test_submissions, "cloze_test_submissions_cloze_test_id_fkey"))

    alter table(:cloze_test_submissions) do
      modify(:cloze_test_id, references(:cloze_tests, on_delete: :delete_all), null: false)
    end
  end

  def down do
    drop(constraint(:cloze_test_submissions, "cloze_test_submissions_cloze_test_id_fkey"))

    alter table(:cloze_test_submissions) do
      modify(:cloze_test_id, references(:cloze_tests, on_delete: :nothing), null: false)
    end
  end
end
