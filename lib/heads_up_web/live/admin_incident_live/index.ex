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
        <:actions>
          <.link navigate={~p"/admin/incidents/new"} class="button">New Incident</.link>
        </:actions>
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
        <:action :let={{_dom_id, incident}}>
          <.link navigate={~p"/admin/incidents/#{incident}/edit"}>Edit</.link>
        </:action>
        <:action :let={{_dom_id, incident}}>
          <.link phx-click="delete" phx-value-id={incident.id} data-confirm="Are you sure?">Delete</.link>
        </:action>
      </.table>
    """
  end

  def handle_event("delete", %{"id" => id}, socket) do
    incident = Admin.get_incident!(id)
    {:ok, _} = Admin.delete_incident(incident)
    socket = stream_delete(socket, :incidents, incident)
    {:noreply, socket}
  end

end
