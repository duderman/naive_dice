defmodule NaiveDice.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :title, :string, null: false
      add :allocation, :integer, null: false

      timestamps()
    end
  end
end
