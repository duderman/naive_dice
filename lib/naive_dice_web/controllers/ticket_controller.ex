defmodule NaiveDiceWeb.TicketController do
  use NaiveDiceWeb, :controller

  alias NaiveDice.Tickets

  def show(conn, %{"id" => ticket_id}) do
    with {:ok, ticket} <- Tickets.get_by_id(ticket_id) do
      template = ticket_template(ticket)
      render(conn, template, %{ticket: ticket})
    end
  end

  defp ticket_template(%{paid_at: nil}), do: :checkout
  defp ticket_template(_), do: :show
end
