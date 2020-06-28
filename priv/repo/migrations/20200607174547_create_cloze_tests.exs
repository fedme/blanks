defmodule Blanks.Repo.Migrations.CreateClozeTests do
  use Ecto.Migration

  def change do
    create table(:cloze_tests) do
      add :name, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :content, :string

      timestamps()
    end

  end
end
