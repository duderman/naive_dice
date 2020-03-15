defmodule NaiveDice.Tickets.Cleaner do
  @reservation_time Application.get_env(:naive_dice, :reservation_time)

  alias NaiveDice.Tickets.Cleaner.{ExpiredTicketsQuery, Deleter}
  require Logger

  @spec clean() :: {integer(), nil | [term()]}
  def clean() do
    @reservation_time
    |> ExpiredTicketsQuery.all()
    |> log()
    |> Deleter.delete()
  end

  defp log([]), do: []

  defp log(tickets) do
    Logger.debug("Removing #{Enum.count(tickets)} expired reservations")
    tickets
  end
end
