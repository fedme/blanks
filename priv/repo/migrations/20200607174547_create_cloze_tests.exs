defmodule Blanks.Repo.Migrations.CreateClozeTests do
  use Ecto.Migration

  def change do
    create table(:cloze_tests) do
      add :name, :string
      add :content, :string

      timestamps()
    end

  end
end
