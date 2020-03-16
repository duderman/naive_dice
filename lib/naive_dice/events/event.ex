defmodule NaiveDice.Events.Event do
  @moduledoc false
  use NaiveDice, :model

  schema "events" do
    field :allocation, :integer
    field :title

    has_many :tickets, NaiveDice.Tickets.Ticket

    timestamps()
  end

  def changeset(event, params \\ %{}) do
    event
    |> cast(params, [:title, :allocation])
    |> validate_required([:title, :allocation])
    |> validate_number(:allocation, greater_than: 0)
  end
end
