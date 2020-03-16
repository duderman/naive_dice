defmodule BuyingTicketTest do
  @moduledoc """
  Test the flow of buying a ticket
  """

  use NaiveDice.IntegrationCase

  alias NaiveDice.Events.Event
  alias NaiveDiceWeb.Endpoint

  import Wallaby.Query, only: [link: 1, text_field: 1, button: 1, css: 2]

  test "Buying a ticket", %{session: session} do
    Repo.insert!(%Event{title: "Yo", allocation: 2})

    session
    |> visit("/")
    |> click(link("Book now"))
    |> fill_in(text_field("user_name"), with: "User")
    |> click(button("Reserve ticket for 5 minutes"))
    |> assert_has(css("p", text: "Nice to meet you User!"))
    # Ticket paid on Stripe
    |> visit(payment_path(Endpoint, :process, %{checkout_session_id: "someid"}))
    |> assert_has(css("h1", text: "Congratulations User!"))
    |> assert_has(css("p", text: "Ticket is yours!"))
    |> click(link("Guests list"))
    |> assert_has(css("li", text: "User"))
    |> click(link("← back to root"))
    |> click(link("Book now"))
    |> assert_has(css("p", text: "only 1 ticket left"))
  end

  test "Concurrent buying", %{session: user1} do
    {:ok, %{id: event_id}} = Repo.insert(%Event{title: "Yo", allocation: 1})
    event_path = event_path(Endpoint, :show, event_id)
    {:ok, user2} = Wallaby.start_session()

    user1
    |> visit(event_path)
    |> fill_in(text_field("user_name"), with: "User1")

    user2
    |> visit(event_path)
    |> fill_in(text_field("user_name"), with: "User2")

    parent = self()

    spawn_link(fn ->
      user1
      |> click(button("Reserve ticket for 5 minutes"))
      |> assert_has(css("p", text: "Nice to meet you User1!"))
    end)

    spawn_link(fn ->
      user2
      |> click(button("Reserve ticket for 5 minutes"))
      |> assert_has(css("p", text: "Sorry. All tickets are gone"))
      |> assert_has(css(".alert-danger", text: "Sorry. Too late :("))

      send(parent, :done)
    end)

    receive do
      :done -> :ok
    end
  end
end
