defmodule NaiveDiceWeb.TicketController do
  use NaiveDiceWeb, :controller
  alias NaiveDice.{Events, Tickets}
  alias NaiveDice.Tickets.Ticket

  action_fallback(NaiveDiceWeb.FallbackController)

  def new(conn, %{"event_id" => event_id}) do
    with {:ok, event} <- Events.get_event_by_id(event_id) do
      remaining_tickets = 5

      render(conn, "new.html", %{
        changeset: Events.new_ticket_changeset(),
        event: event,
        remaining_tickets: remaining_tickets
      })
    end
  end

  def show(conn, %{"id" => ticket_id}) do
    with {:ok, ticket} <- Tickets.get_by_id(ticket_id) do
      render(conn, "show.html", %{ticket: ticket})
    end
  end

  def reserve(conn, %{"event_id" => event_id, "ticket" => %{"user_name" => user_name}}) do
    with {:ok, event} <- Events.get_by_id(event_id),
         {:error, :not_found} <- Tickets.get_by_event_id_and_user_name(event.id, user_name),
         {:ok, item} <- Stripe.Item.build(event),
         {:ok, checkout_session_id} <-
           Stripe.CheckoutSession.create(
             item,
             Routes.callback_url(conn, :success),
             Routes.callback_url(conn, :cancel)
           ),
         {:ok, ticket} <- Tickets.reserve(event.id, user_name, checkout_session_id) do
      conn |> redirect(to: Routes.ticket_path(conn, :edit, ticket.id))
    else
      {:ok, ticket = %Ticket{}} ->
        conn |> redirect(to: Routes.ticket_path(conn, :show, ticket.id))
    end
  end

  @doc """
  Updates a ticket with the charge details and redirects to the confirmation / receipt / thank you
  """
  def update(conn, %{"id" => ticket_id}) do
    # TODO: implement this
    conn |> redirect(to: Routes.ticket_path(conn, :show, ticket_id))
  end

  # ADMIN ACTIONS

  @doc """
  Helper method which returns the system into the original state (useful for testing)
  """
  def reset_guests(conn, _params) do
    # TODO: delete all tickets here.

    conn
    |> put_flash(:info, "All tickets deleted. Starting from scratch.")
    |> redirect(to: "/")
  end
end
