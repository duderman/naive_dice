defmodule NaiveDiceWeb.GuestController do
  use NaiveDiceWeb, :controller

  alias NaiveDice.Events
  alias NaiveDice.Events.{GuestNamesQuery, Reset}

  def index(conn, %{"event_id" => event_id}) do
    with {:ok, _event} <- Events.get_by_id(event_id) do
      guest_names = GuestNamesQuery.all(event_id)
      render(conn, "index.html", %{guest_names: guest_names, event_id: event_id})
    end
  end

  def reset(conn, %{"event_id" => event_id}) do
    with {:ok, _event} <- Events.get_by_id(event_id) do
      Reset.reset(event_id)

      conn
      |> put_flash(:info, "All tickets deleted. Starting from scratch.")
      |> redirect(to: Routes.event_path(conn, :show, event_id))
    end
  end
end
