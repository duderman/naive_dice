defmodule NaiveDiceWeb.ErrorView do
  use NaiveDiceWeb, :view

  def render("404.html", _assigns) do
    "HTTP 404: resource (e.g. Event) not found"
  end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end
end
