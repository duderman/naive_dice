defmodule NaiveDice.Events.GuestNamesQuery do
  use NaiveDice, :query

  @spec all(String.t()) :: list(String.t())
  def all(event_id) do
    event_id
    |> to_query
    |> Repo.all()
  end

  defp to_query(event_id) do
    from t in Ticket,
      where: t.event_id == ^event_id,
      select: t.user_name
  end
end
