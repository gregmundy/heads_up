defmodule HeadsUpWeb.AdminIncidentLive.Index do
  use HeadsUpWeb, :live_view
  import HeadsUpWeb.CustomComponents

  alias HeadsUp.Admin

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:page_title, "Admin Incidents")
      |> stream(:incidents, Admin.list_incidents())

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="admin-index">
      <.header>
        <%= @page_title %>
      </.header>
      </div>
      <.table id="incidents" rows={@streams.incidents}>
        <:col :let={{_dom_id, incidents}} label="Incident">
          <.link navigate={~p"/incidents/#{incidents.id}"}>
            <%= incidents.name %>
          </.link>
        </:col>
        <:col :let={{_dom_id, incidents}} label="Status">
          <.badge status={incidents.status} />
        </:col>
        <:col :let={{_dom_id, incidents}} label="Priority">
          <%= incidents.priority %>
        </:col>
      </.table>
    """
  end
end