defmodule NaiveDice do
  @moduledoc """
  NaiveDice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def model do
    quote do
      use NaiveDice.Schema
      import Ecto.Changeset
    end
  end

  def query do
    quote do
      import Ecto.Query
      alias NaiveDice.Repo
      alias NaiveDice.Tickets.Ticket
      alias NaiveDice.Events.Event
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
