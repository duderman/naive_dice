defmodule NaiveDice.Events.Ticket do
  @moduledoc """
  This schema represents a purchased ticket

  TODO: should we use the same schema to represent a pending reservation?
  """

  use Ecto.Schema
  import Ecto.Changeset

  # TODO: the schema is far from beging complete:
  schema "tickets" do
    field :user_name, :string
    field :checkout_session_id, :string

    timestamps()
  end

  @doc false
  def changeset(ticket, attrs \\ %{}) do
    ticket
    |> cast(attrs, [:user_name, :checkout_session_id])
    |> validate_required([:user_name, :checkout_session_id])
  end
end
