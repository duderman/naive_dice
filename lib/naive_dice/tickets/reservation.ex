defmodule NaiveDice.Tickets.Reservation do
  alias NaiveDice.{Tickets, Events}
  alias NaiveDice.Tickets.Ticket
  alias NaiveDice.Events.Event
  alias NaiveDice.Repo

  @spec reserve(%Event{}, String.t(), String.t()) ::
          {:ok, %Ticket{}}
          | {:error, {:exist, %Ticket{}} | :no_tickets_left | Ecto.Changeset.t() | String.t()}
  def reserve(event = %Event{id: event_id}, user_name, callback_url) do
    Mutex.under(EventsMutex, event_id, fn ->
      do_reserve(event, user_name, callback_url)
    end)
  end

  def do_reserve(event = %Event{id: event_id}, user_name, callback_url) do
    with {:ok, :doesnt_exist} <- ticket_exists?(event_id, user_name),
         :ok <- tickets_left?(event),
         {:ok, checkout_session_id} <- Stripe.CheckoutSession.Creator.create(event, callback_url) do
      create_ticket(event_id, user_name, checkout_session_id)
    end
  end

  defp ticket_exists?(event_id, user_name) do
    case Tickets.get_by_event_id_and_user_name(event_id, user_name) do
      {:error, :not_found} -> {:ok, :doesnt_exist}
      {:ok, ticket} -> {:error, {:exist, ticket}}
    end
  end

  defp create_ticket(event_id, user_name, checkout_session_id) do
    %Ticket{}
    |> Ticket.changeset(%{
      event_id: event_id,
      user_name: user_name,
      checkout_session_id: checkout_session_id
    })
    |> Repo.insert()
  end

  defp tickets_left?(event = %Event{}) do
    event
    |> Events.remaining_tickets()
    |> tickets_left?()
  end

  defp tickets_left?(count) when is_number(count) and count > 0, do: :ok
  defp tickets_left?(0), do: {:error, :no_tickets_left}
end
