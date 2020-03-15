defmodule NaiveDice.Tickets.Cleaner.ExpiredTicketsQuery do
  use NaiveDice, :query
  alias NaiveDice.Tickets.Ticket

  @spec all(integer) :: list(%Ticket{})
  def all(ttl) do
    tickets()
    |> not_paid()
    |> reserved_ms_ago(ttl)
    |> Repo.all()
  end

  defp tickets do
    from(t in Ticket)
  end

  defp not_paid(query) do
    query |> where([t], is_nil(t.paid_at))
  end

  defp reserved_ms_ago(query, ttl) do
    query |> where([t], t.inserted_at <= ^ms_ago(ttl))
  end

  defp ms_ago(ttl) do
    DateTime.utc_now()
    |> DateTime.add(-ttl, :millisecond)
  end
end
