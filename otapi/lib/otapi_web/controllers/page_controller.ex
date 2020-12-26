defmodule OtapiWeb.PageController do
  use OtapiWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
