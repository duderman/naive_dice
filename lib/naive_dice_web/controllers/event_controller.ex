defmodule NaiveDiceWeb.EventController do
  use NaiveDiceWeb, :controller

  alias NaiveDice.Events

  def index(conn, _params) do
    events = Events.all()

    render(conn, "index.html", %{events: events})
  end

  def show(conn, %{"id" => id}) do
    with {:ok, event} <- Events.get_by_id(id) do
      remaining_tickets = NaiveDice.Events.remaining_tickets(event)
      reservation_time = Events.reservation_time_in_minutes()

      render(conn, "show.html", %{
        event: event,
        remaining_tickets: remaining_tickets,
        reservation_time: reservation_time
      })
    end
  end

  def reserve(conn, %{"event_id" => event_id, "user_name" => user_name}) do
    with {:ok, event} <- Events.get_by_id(event_id) do
      callback_url = build_callback_url(conn)

      case NaiveDice.Tickets.Reservation.reserve(event, user_name, callback_url) do
        {:ok, ticket} ->
          redirect_to_ticket(conn, ticket)

        {:error, {:exist, ticket}} ->
          conn
          |> put_flash(:info, "Ticket already exists")
          |> redirect_to_ticket(ticket)

        {:error, :no_tickets_left} ->
          conn
          |> put_flash(:error, "Sorry. Too late :(")
          |> redirect_to_event(event)

        {:error, message} when is_binary(message) ->
          conn
          |> put_flash(:error, message)
          |> redirect_to_event(event)
      end
    end
  end

  defp redirect_to_ticket(conn, %{id: id}), do: redirect_to_ticket(conn, id)

  defp redirect_to_ticket(conn, id) when is_binary(id) do
    redirect(conn, to: Routes.ticket_path(conn, :show, id))
  end

  defp redirect_to_event(conn, %{id: id}), do: redirect_to_event(conn, id)

  defp redirect_to_event(conn, id) when is_binary(id) do
    redirect(conn, to: Routes.event_path(conn, :show, id))
  end

  defp build_callback_url(conn) do
    Routes.payment_url(conn, :process) <> "?checkout_session_id={CHECKOUT_SESSION_ID}"
  end
end
