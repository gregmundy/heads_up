defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    # socket =
    #   socket
    #   |> stream(:incidents, Incidents.list_incidents())
    #   |> assign(:form, to_form(%{}))

    # IO.inspect(socket.assigns.streams.incidents, label: "MOUNT")

    # socket =
    #   attach_hook(socket, :log_stream, :after_render, fn socket ->
    #     IO.inspect(socket.assigns.streams.incidents, label: "AFTER RENDER")
    #     socket
    #   end)

    {:ok, socket}
  end

  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> stream(:incidents, Incidents.filter_incidents(params), reset: true)
      |> assign(:form, to_form(params))

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <.headline>
      <.icon name="hero-trophy-mini" /> 25 Incidents Resolved This Month!
      <:tagline :let={vibe}>
        Thanks for pitching in. <%= vibe %>
      </:tagline>
      <:tagline>
        Every little bit helps!
      </:tagline>
    </.headline>

    <div class="incident-index">
      <.filter_form form={@form} />
      <div class="incidents" id="incidents" phx-update="stream">
        <.incident_card
          :for={{dom_id, incident} <- @streams.incidents}
          incident={incident}
          id={dom_id}
        />
      </div>
    </div>
    """
  end

  attr :form, :map, required: true

  def filter_form(assigns) do
    ~H"""
    <.form for={@form} id="filter-form" phx-change="filter">
      <.input field={@form[:q]} placeholder="Search..." autocomplete="off" phx-debounce="500" />
      <.input
        type="select"
        field={@form[:status]}
        prompt="Status"
        options={Ecto.Enum.values(Incidents.Incident, :status)}
      />
      <.input
        type="select"
        field={@form[:sort_by]}
        prompt="Sort By"
        options={[
          Name: "name",
          "Priority: Low to High": "priority_asc",
          "Priority: High to Low": "priority_desc"
        ]}
      />
      <.link patch={~p"/incidents"}>Reset</.link>
    </.form>
    """
  end

  def handle_event("filter", params, socket) do
    params =
      params
      |> Map.take(~w(q status sort_by))
      |> Map.reject(fn {_, v} -> v == "" end)

    socket = push_patch(socket, to: ~p"/incidents?#{params}")

    {:noreply, socket}
  end
end
