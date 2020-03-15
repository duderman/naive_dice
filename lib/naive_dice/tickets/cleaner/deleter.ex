defmodule NaiveDice.Tickets.Cleaner.Deleter do
  use NaiveDice, :query

  alias NaiveDice.Tickets.Ticket

  @spec delete(list(%Ticket{})) :: {integer, nil | [term]}
  def delete([]), do: {0, nil}

  def delete(tickets) do
    tickets
    |> Enum.map(& &1.id)
    |> to_query()
    |> Repo.delete_all()
  end

  defp to_query(ids) do
    from t in Ticket, where: t.id in ^ids
  end
end
