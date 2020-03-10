defmodule NaiveDice.Tickets do
  alias NaiveDice.Tickets.Ticket
  alias NaiveDice.Events.Event
  alias NaiveDice.{Repo, RepoHelpers}

  @spec reserve(%Event{}, String.t(), String.t()) :: {:ok, %Ticket{}}
  def reserve(event, user_name, checkout_session_id) do
    %Ticket{}
    |> to_changeset(event, user_name, checkout_session_id)
    |> Repo.insert()
  end

  @spec get_by_id(String.t()) :: {:ok, %Ticket{}} | {:error, :not_found}
  def get_by_id(id) do
    Ticket
    |> Repo.get(id)
    |> RepoHelpers.get_result()
  end

  @spec get_by_event_id_and_user_name(String.t(), String.t()) ::
          {:error, :not_found} | {:ok, %Ticket{}}
  def get_by_event_id_and_user_name(event_id, user_name) do
    Ticket
    |> Repo.get_by(%{event_id: event_id, user_name: user_name})
    |> RepoHelpers.get_result()
  end

  defp to_changeset(ticket, event, user_name, checkout_session_id) do
    Ticket.changeset(ticket, %{
      event: event,
      user_name: user_name,
      checkout_session_id: checkout_session_id
    })
  end
end
