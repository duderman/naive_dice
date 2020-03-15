defmodule NaiveDiceWeb.TicketController do
  use NaiveDiceWeb, :controller

  alias NaiveDice.{Tickets, Events}

  def show(conn, %{"id" => ticket_id}) do
    with {:ok, ticket} <- Tickets.get_by_id(ticket_id) do
      reservation_time = Events.reservation_time_in_minutes()
      template = ticket_template(ticket)
      render(conn, template, %{ticket: ticket, reservation_time: reservation_time})
    end
  end

  defp ticket_template(%{paid_at: nil}), do: :checkout
  defp ticket_template(_), do: :show
end
