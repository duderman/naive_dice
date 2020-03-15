defmodule NaiveDice.Events.Event do
  use NaiveDice, :model

  schema "events" do
    field :allocation, :integer
    field :title

    timestamps()
  end

  def changeset(event, params \\ %{}) do
    event
    |> cast(params, [:title, :allocation])
    |> validate_required([:title, :allocation])
    |> validate_number(:allocation, greater_than: 0)
  end
end
