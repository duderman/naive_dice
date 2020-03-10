defmodule NaiveDiceWeb.PaymentController do
  use NaiveDiceWeb, :controller

  alias NaiveDice.Tickets

  def process(conn, %{"checkout_session_id" => checkout_session_id}) do
    with {:ok, ticket} <- Tickets.get_by_checkout_session_id(checkout_session_id),
         {:ok, status} <- Stripe.CheckoutSession.StatusChecker.check(checkout_session_id),
         {:ok, %{id: id}} <- Tickets.update_status(ticket, status) do
      redirect(conn, to: Routes.ticket_path(conn, :show, id))
    else
      {:error, :canceled, %{event_id: event_id}} ->
        conn
        |> put_flash(:error, "Purchase was cancelled")
        |> redirect(to: Routes.event_path(conn, :show, event_id))

      {:error, :wrong_status, %{id: id}} ->
        conn
        |> put_flash(:error, "Something wrong with the payment. Try again Please")
        |> redirect(to: Routes.ticket_ticket_path(conn, :checkout, id))
    end
  end
end
