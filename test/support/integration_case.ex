defmodule NaiveDice.IntegrationCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias NaiveDice.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import NaiveDiceWeb.Router.Helpers
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(NaiveDice.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(NaiveDice.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(NaiveDice.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
