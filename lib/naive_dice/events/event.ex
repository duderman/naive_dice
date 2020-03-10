defmodule NaiveDice.Events.Event do
  use NaiveDice.Schema
  import Ecto.Changeset

  schema "events" do
    field :allocation, :integer
    field :title

    timestamps()
  end
end
