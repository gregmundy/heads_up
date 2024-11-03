defmodule HeadsUpWeb.TipController do
  use HeadsUpWeb, :controller

  alias HeadsUp.Tips

  def index(conn, _params) do
    emoji = ~w(😍 🥳 🤩 🥸 😘) |> Enum.random() |> String.duplicate(5)
    tips = Tips.list_tips()
    render(conn, :index, emoji: emoji, tips: tips)
  end

  def show(conn, %{"id" => id}) do
    tip = Tips.get_tip(id)
    render(conn, :show, tip: tip)
  end
end
