defmodule NaiveDice.Tickets.Ticket do
  @moduledoc """
  This schema represents a purchased ticket
  """

  use NaiveDice.Schema
  import Ecto.Changeset

  schema "tickets" do
    belongs_to :event, NaiveDice.Events.Event
    field :user_name, :string
    field :checkout_session_id, :string
    field :paid_at, :utc_datetime

    timestamps()
  end

  def changeset(ticket, attrs \\ %{}) do
    ticket
    |> cast(attrs, [:event_id, :user_name, :checkout_session_id, :paid_at])
    |> validate_required([:user_name, :checkout_session_id])
    |> assoc_constraint(:event)
    |> unique_constraint(:checkout_session_id)
    |> unique_constraint(:user_name, name: :tickets_event_id_user_name_index)
  end
end
