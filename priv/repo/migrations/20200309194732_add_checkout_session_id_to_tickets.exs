defmodule NaiveDice.Repo.Migrations.AddCheckoutSessionIdToTickets do
  use Ecto.Migration

  def change do
    alter table("tickets") do
      add :checkout_session_id, :string, null: false
    end
  end
end
