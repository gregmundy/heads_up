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
    <div class="mb-5">
      <.button phx-click={
        JS.toggle(
          to: "#joke",
          in: {"ease-in-out duration-300", "opacity-0", "opacity-100"},
          out: {"ease-in-out duration-300", "opacity-100", "opacity-0"},
          time: 300
        )
      }>
        Toggle Joke
      </.button>
      <div
        id="joke"
        class="joke bg-gray-100 p-4 rounded-md mt-2 hidden"
        phx-click={
          JS.toggle_class("blur-sm",
            transition: {"fade-out duration-300", "opacity-50", "opacity-100"}
          )
        }
      >
        Why shouldn't you trust trees?
      </div>
    </div>
    <div class="admin-index">
      <.header>
        <%= @page_title %>
        <:actions>
          <.link navigate={~p"/admin/incidents/new"} class="button">New Incident</.link>
        </:actions>
      </.header>
    </div>
    <.table
      id="incidents"
      rows={@streams.incidents}
      row_click={
        fn {_, incident} ->
          JS.navigate(~p"/incidents/#{incident.id}")
        end
      }
    >
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
      <:action :let={{dom_id, incident}}>
        <.link phx-click={delete_and_hide(dom_id, incident)} data-confirm="Are you sure?">
          Delete
        </.link>
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

  def delete_and_hide(dom_id, incident) do
    JS.push("delete", value: %{id: incident.id})
    |> JS.hide(to: "##{dom_id}", transition: "fade-out")
  end
end
