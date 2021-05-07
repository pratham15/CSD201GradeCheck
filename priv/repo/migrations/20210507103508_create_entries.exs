defmodule PercentageCalc.Repo.Migrations.CreateEntries do
  use Ecto.Migration

  def change do
    create table(:entries) do
      add :name, :string
      add :email, :string
      add :percentage, :float

      timestamps()
    end

    create unique_index(:entries, [:email], name: :entries_email)
  end
end
