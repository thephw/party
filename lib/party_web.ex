defmodule PartyWeb do
  @moduledoc """
  The entrypoint for defining your web interface, such
  as controllers, components, channels, and so on.

  This can be used in your application as:

      use PartyWeb, :controller
      use PartyWeb, :html

  The definitions below will be executed for every controller,
  component, etc, so keep them short and clean, focused
  on imports, uses and aliases.

  Do NOT define functions inside the quoted expressions
  below. Instead, define additional modules and import
  those modules here.
  """

  def static_paths, do: ~w(
    android-icon-144x144.png
    android-icon-192x192.png
    android-icon-36x36.png
    android-icon-48x48.png
    android-icon-72x72.png
    android-icon-96x96.png
    apple-icon-114x114.png
    apple-icon-120x120.png
    apple-icon-144x144.png
    apple-icon-152x152.png
    apple-icon-180x180.png
    apple-icon-57x57.png
    apple-icon-60x60.png
    apple-icon-72x72.png
    apple-icon-76x76.png
    apple-icon-precomposed.png
    apple-icon.png
    assets
    browserconfig.xml
    favicon-16x16.png
    favicon-32x32.png
    favicon-96x96.png
    favicon.ico
    images
    manifest.json
    ms-icon-144x144.png
    ms-icon-150x150.png
    ms-icon-310x310.png
    ms-icon-70x70.png
    robots.txt
  )

  def router do
    quote do
      use Phoenix.Router, helpers: false

      # Import common connection and controller functions to use in pipelines
      import Plug.Conn
      import Phoenix.Controller
      import Phoenix.LiveView.Router
    end
  end

  def channel do
    quote do
      use Phoenix.Channel
    end
  end

  def controller do
    quote do
      use Phoenix.Controller,
        formats: [:html, :json],
        layouts: [html: PartyWeb.Layouts]

      import Plug.Conn
      import PartyWeb.Gettext

      unquote(verified_routes())
    end
  end

  def live_view do
    quote do
      use Phoenix.LiveView,
        layout: {PartyWeb.Layouts, :app}

      unquote(html_helpers())
    end
  end

  def live_component do
    quote do
      use Phoenix.LiveComponent

      unquote(html_helpers())
    end
  end

  def html do
    quote do
      use Phoenix.Component

      # Import convenience functions from controllers
      import Phoenix.Controller,
        only: [get_csrf_token: 0, view_module: 1, view_template: 1]

      # Include general helpers for rendering HTML
      unquote(html_helpers())
    end
  end

  defp html_helpers do
    quote do
      # HTML escaping functionality
      import Phoenix.HTML
      # Core UI components and translation
      import PartyWeb.CoreComponents
      import PartyWeb.Gettext

      # Shortcut for generating JS commands
      alias Phoenix.LiveView.JS

      # Routes generation with the ~p sigil
      unquote(verified_routes())
    end
  end

  def verified_routes do
    quote do
      use Phoenix.VerifiedRoutes,
        endpoint: PartyWeb.Endpoint,
        router: PartyWeb.Router,
        statics: PartyWeb.static_paths()
    end
  end

  @doc """
  When used, dispatch to the appropriate controller/view/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
