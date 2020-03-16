defmodule NaiveDice.Events.BoughtTicketsQuery do
  @moduledoc """
  Query to get amount of bought tickets for a specific event
  """
  use NaiveDice, :query

  def count(event_id) do
    event_id
    |> all()
    |> select([t], count(t.id))
    |> Repo.one()
  end

  defp all(event_id) do
    from e in Ticket,
      where: e.event_id == ^event_id
  end
end
