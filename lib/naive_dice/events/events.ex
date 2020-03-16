defmodule NaiveDice.Events do
  @moduledoc false
  alias NaiveDice.Events.{BoughtTicketsQuery, Event}
  alias NaiveDice.{Repo, RepoHelpers}

  @spec all :: list(%Event{})
  def all do
    Repo.all(Event)
  end

  @spec get_by_id(String.t()) :: {:ok, %Event{}} | {:error, :not_found}
  def get_by_id(id) do
    Event
    |> Repo.get(id)
    |> RepoHelpers.get_result()
  end

  @spec remaining_tickets(%Event{}) :: integer
  def remaining_tickets(%{id: event_id, allocation: allocation}) do
    event_id
    |> BoughtTicketsQuery.count()
    |> (&(allocation - &1)).()
    |> max(0)
  end

  @spec reservation_time_in_minutes() :: integer
  def reservation_time_in_minutes do
    Application.get_env(:naive_dice, :reservation_time)
    |> (&(&1 / 60_000)).()
    |> round()
  end
end
