defmodule NaiveDice.Repo.Migrations.CreateTickets do
  use Ecto.Migration

  def change do
    create table(:tickets, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :event_id, references(:events, type: :binary_id)
      add :user_name, :string, null: false
      add :checkout_session_id, :string, null: false
      add :paid_at, :utc_datetime

      timestamps()
    end

    create unique_index(:tickets, [:event_id, :user_name])
    create unique_index(:tickets, :checkout_session_id)
  end
end
