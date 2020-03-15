defmodule NaiveDice.Events.Reset do
  use NaiveDice, :query

  @spec reset(Stirng.t()) :: {integer, nil | [term]}
  def reset(event_id) do
    event_id
    |> to_query()
    |> Repo.delete_all()
  end

  defp to_query(event_id) do
    from t in Ticket, where: t.event_id == ^event_id
  end
end
