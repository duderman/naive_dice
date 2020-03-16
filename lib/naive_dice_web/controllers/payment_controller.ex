defmodule NaiveDiceWeb.PaymentController do
  use NaiveDiceWeb, :controller

  alias NaiveDice.Tickets
  alias Stripe.CheckoutSession.StatusChecker

  def process(conn, %{"checkout_session_id" => checkout_session_id}) do
    with {:ok, ticket} <- Tickets.get_by_checkout_session_id(checkout_session_id),
         {:ok, status} <- StatusChecker.check(checkout_session_id) do
      case Tickets.update_status(ticket, status) do
        {:ok, %{id: id}} ->
          redirect(conn, to: Routes.ticket_path(conn, :show, id))

        {:error, :deleted, %{event_id: event_id}} ->
          conn
          |> put_flash(:error, "Purchase was cancelled")
          |> redirect(to: Routes.event_path(conn, :show, event_id))

        {:error, :unknown_status, %{id: id}} ->
          conn
          |> put_flash(:error, "Something went wrong with the payment. Try again Please")
          |> redirect(to: Routes.ticket_path(conn, :show, id))
      end
    end
  end
end
