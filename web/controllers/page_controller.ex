defmodule TheTranscriberBackend.PageController do
  use TheTranscriberBackend.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
