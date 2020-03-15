defmodule NaiveDiceWeb.ViewHelpers do
  use Phoenix.HTML
  import NaiveDiceWeb.Router.Helpers

  def back_to_root_link do
    link("← back to root", to: event_path(NaiveDiceWeb.Endpoint, :index))
  end

  def pluralize(word, 1), do: word
  def pluralize(word, _), do: word <> "s"

  def guests_link(event_id) do
    link("Guests list", to: event_guest_path(NaiveDiceWeb.Endpoint, :index, event_id))
  end
end
