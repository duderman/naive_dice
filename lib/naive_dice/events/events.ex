defmodule NaiveDice.Events do
  alias NaiveDice.Events.Event
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
end
