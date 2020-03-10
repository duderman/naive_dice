defmodule NaiveDiceWeb.EventController do
  use NaiveDiceWeb, :controller

  alias NaiveDice.Events
  alias NaiveDice.Tickets
  alias NaiveDice.Tickets.Ticket

  def index(conn, _params) do
    events = Events.all()

    render(conn, "index.html", %{events: events})
  end

  def show(conn, %{"id" => id}) do
    remaining_tickets = 5

    with {:ok, event} <- Events.get_by_id(id) do
      render(conn, "show.html", %{event: event, remaining_tickets: remaining_tickets})
    end
  end

  def reserve(conn, %{"event_id" => event_id, "user_name" => user_name}) do
    with {:error, :not_found} <- Tickets.get_by_event_id_and_user_name(event_id, user_name),
         {:ok, event} <- Events.get_by_id(event_id),
         callback_url = build_callback_url(conn),
         {:ok, checkout_session_id} <- Stripe.CheckoutSession.create(event, callback_url),
         {:ok, ticket} <- Tickets.reserve(event, user_name, checkout_session_id) do
      conn |> redirect(to: Routes.ticket_ticket_path(conn, :checkout, ticket.id))
    else
      {:ok, ticket = %Ticket{}} ->
        conn
        |> put_flash(:info, "Ticket is already bought")
        |> redirect(to: Routes.ticket_path(conn, :show, ticket.id))
    end
  end

  defp build_callback_url(conn) do
    Routes.payment_url(conn, :process) <> "?session_id={CHECKOUT_SESSION_ID}"
  end
end
