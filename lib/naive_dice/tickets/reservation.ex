defmodule NaiveDice.Tickets.Reservation do
  alias NaiveDice.Tickets
  alias NaiveDice.Tickets.Ticket
  alias NaiveDice.Events.Event
  alias NaiveDice.Repo

  @spec reserve(%Event{}, String.t(), String.t()) :: {:ok, %Ticket{}} | {:error, {:exist, %Ticket{}} | Ecto.Changeset.t() | String.t()}
  def reserve(event = %Event{id: event_id}, user_name, callback_url) do
    with {:ok, :doesnt_exist} <- ticket_exists?(event_id, user_name),
         {:ok, checkout_session_id} <- Stripe.CheckoutSession.Creator.create(event, callback_url) do
      do_reserve(event_id, user_name, checkout_session_id)
    end
  end

  defp ticket_exists?(event_id, user_name) do
    case Tickets.get_by_event_id_and_user_name(event_id, user_name) do
      {:error, :not_found} -> {:ok, :doesnt_exist}
      {:ok, ticket} -> {:error, {:exist, ticket}}
    end
  end

  defp do_reserve(event_id, user_name, checkout_session_id) do
    %Ticket{}
    |> Ticket.changeset(%{event_id: event_id, user_name: user_name, checkout_session_id: checkout_session_id})
    |> Repo.insert()
  end
end
