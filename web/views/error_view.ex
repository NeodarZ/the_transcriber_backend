defmodule TheTranscriberBackend.ErrorView do
  use TheTranscriberBackend.Web, :view

  def render("404.html", _assigns) do
    "Page not found"
  end

  def render("500.html", _assigns) do
    "Internal server error"
  end

  # In case no render clause matches or no
  # template is found, let's render it as 500
  def template_not_found(_template, assigns) do
    render "500.html", assigns
  end

  def render("404.json", %{reason: reason}) do
  message = case reason do
    %Phoenix.Router.NoRouteError{} -> "Route not found"
    %Ecto.NoResultsError{} -> "File not found in database !"
    _ -> "Uncaught exception"
  end
  # ContactService.ResponseHelper.error(message)
  %{error: message}
end

end
