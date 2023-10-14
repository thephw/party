defmodule PartyWeb.PageController do
  use PartyWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn =
      conn
      |> assign(:page_title, "Scareoke Halloween Party")
      |> assign(:description, "Costume contest and karoke party!")

    render(conn, :home, layout: false)
  end
end
