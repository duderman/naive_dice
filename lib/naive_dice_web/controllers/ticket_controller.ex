defmodule NaiveDiceWeb.TicketController do
  use NaiveDiceWeb, :controller

  alias NaiveDice.Tickets

  def show(conn, %{"id" => ticket_id}) do
    with {:ok, ticket} <- Tickets.get_by_id(ticket_id) do
      render(conn, "show.html", %{ticket: ticket})
    end
  end

  def checkout(conn, %{"ticket_id" => ticket_id}) do
    with {:ok, ticket} <- Tickets.get_by_id(ticket_id) do
      render(conn, "checkout.html", %{ticket: ticket})
    end
  end
end
