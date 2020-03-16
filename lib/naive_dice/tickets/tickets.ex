defmodule NaiveDice.Tickets do
  @moduledoc false
  alias NaiveDice.Tickets.Ticket
  alias NaiveDice.{Repo, RepoHelpers}

  @spec get_by_id(String.t()) :: {:ok, %Ticket{}} | {:error, :not_found}
  def get_by_id(id) do
    Ticket
    |> Repo.get(id)
    |> RepoHelpers.get_result()
  end

  @spec get_by_event_id_and_user_name(String.t(), String.t()) ::
          {:error, :not_found} | {:ok, %Ticket{}}
  def get_by_event_id_and_user_name(event_id, user_name) do
    Ticket
    |> Repo.get_by(%{event_id: event_id, user_name: user_name})
    |> RepoHelpers.get_result()
  end

  @spec get_by_checkout_session_id(String.t()) :: {:error, :not_found} | {:ok, %Ticket{}}
  def get_by_checkout_session_id(checkout_session_id) do
    Ticket
    |> Repo.get_by(%{checkout_session_id: checkout_session_id})
    |> RepoHelpers.get_result()
  end

  @spec paid(%Ticket{}) :: {:ok, %Ticket{}} | {:error, Ecto.Changeset.t()}
  def paid(ticket) do
    ticket
    |> Ticket.changeset(%{paid_at: DateTime.utc_now()})
    |> Repo.update()
  end

  @spec delete!(%Ticket{}) :: %Ticket{}
  def delete!(ticket) do
    Repo.delete!(ticket)
  end

  @spec update_status(%Ticket{}, String.t()) ::
          {:ok, %Ticket{}}
          | {:error, Ecto.Changeset.t()}
          | {:error, :deleted | :unknown_status, %Ticket{}}
  def update_status(ticket, "succeeded"), do: paid(ticket)

  def update_status(ticket, "canceled") do
    delete!(ticket)
    {:error, :deleted, ticket}
  end

  def update_status(ticket, _), do: {:error, :unknown_status, ticket}
end
