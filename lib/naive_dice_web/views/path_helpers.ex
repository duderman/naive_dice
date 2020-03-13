defmodule NaiveDiceWeb.ViewHelpers do
  use Phoenix.HTML
  import NaiveDiceWeb.Router.Helpers

  def back_to_root_link do
    link("← back to root", to: event_path(NaiveDiceWeb.Endpoint, :index))
  end
end
