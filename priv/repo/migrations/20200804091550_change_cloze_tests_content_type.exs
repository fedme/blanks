defmodule Blanks.Repo.Migrations.ChangeClozeTestsContentType do
  use Ecto.Migration

  def change do
    alter table(:cloze_tests) do
      modify :content, :text
    end
  end

end
