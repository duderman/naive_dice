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
      render(conn, "show.html", %{event: event, remaining_tickets: remaining_tickets})
    end
  end

  def reserve(conn, %{"event_id" => event_id, "user_name" => user_name}) do
    with {:ok, event} <- Events.get_by_id(event_id) do
      callback_url = build_callback_url(conn)
      case NaiveDice.Tickets.Reservation.reserve(event, user_name, callback_url) do
        {:ok, ticket} ->
          conn |> redirect(to: Routes.ticket_path(conn, :show, ticket.id))
        {:error, { :exist, ticket }} ->
          conn
          |> put_flash(:info, "Ticket already exists")
          |> redirect(to: Routes.ticket_path(conn, :show, ticket.id))
        {:error, message} when is_binary(message) ->
          conn
          |> put_flash(:error, message)
          |> redirect(to: Routes.event_path(conn, :show, event_id))
      end
    end
  end

  defp build_callback_url(conn) do
    Routes.payment_url(conn, :process) <> "?checkout_session_id={CHECKOUT_SESSION_ID}"
  end
end
