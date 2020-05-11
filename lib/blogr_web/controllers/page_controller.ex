defmodule BlogrWeb.PageController do
  use BlogrWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
