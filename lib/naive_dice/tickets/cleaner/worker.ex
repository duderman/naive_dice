defmodule NaiveDice.Tickets.Cleaner.Worker do
  @moduledoc """
  GenServer that periodically runs Cleaner
  """
  @periodicity Application.get_env(:naive_dice, :tickets_cleaning_period, 1000)

  use GenServer

  alias NaiveDice.Tickets.Cleaner

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule()
    {:ok, state}
  end

  def handle_info(:clean, state) do
    clean()
    schedule()
    {:noreply, state}
  end

  defp schedule do
    Process.send_after(self(), :clean, @periodicity)
  end

  defp clean do
    Cleaner.clean()
  end
end
