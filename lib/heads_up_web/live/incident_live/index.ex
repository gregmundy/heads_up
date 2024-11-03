defmodule HeadsUpWeb.IncidentLive.Index do
  use HeadsUpWeb, :live_view
  alias HeadsUp.Incidents
  import HeadsUpWeb.CustomComponents

  def mount(_params, _session, socket) do
    {:ok, assign(socket, incidents: Incidents.list_incidents())}
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
      <div class="incidents">
        <.incident_card :for={incident <- @incidents} incident={incident} />
      </div>
    </div>
    """
  end
end
