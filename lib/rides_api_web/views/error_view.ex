defmodule RidesApiWeb.ErrorView do
  use RidesApiWeb, :view

  # If you want to customize a particular status code
  # for a certain format, you may uncomment below.
  # def render("500.html", _assigns) do
  #   "Internal Server Error"
  # end

  # By default, Phoenix returns the status message from
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def template_not_found(template, _assigns) do
    Phoenix.Controller.status_message_from_template(template)
  end

  @doc "Provides error json render clause for 400 status code"
  def render("400.json", _assigns) do
    %{error: "Query parameters invalid"}
  end

  @doc "Provides error json render clause for 503 status code"
  def render("503.json", _assigns) do
    %{error: "Service temporarily unavailable"}
  end
end
