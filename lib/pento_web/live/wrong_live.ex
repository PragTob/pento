defmodule PentoWeb.WrongLive do
  use PentoWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(unsigned_params, uri, socket) do
    {:noreply,
     assign(socket,
       score: 0,
       message: "Make a guess:",
       time: time(),
       secret: random_number(),
       won?: false
     )}
  end

  @range 1..10
  defp range do
    @range
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1 class="mb-4 text-4xl font-extrabold">Your score: <%= @score %></h1>
    <h2>
      <%= @message %> <br />It's <%= @time %>
    </h2>
    <br />
    <h2>
      <%= for n <- range() do %>
        <.link
          class="bg-blue-500 hover:bg-blue-700
    text-white font-bold py-2 px-4 border border-blue-700 rounded m-1"
          phx-click="guess"
          phx-value-number={n}
        >
          <%= n %>
        </.link>
      <% end %>
      <%= if @won? do %>
        <br />
        <.link
          patch={~p"/guess"}
          class="bg-green-500 hover:bg-green-700 text-white font-bold py-2 px-4 border border-green-700 rounded m-1"
        >
          Restart game
        </.link>
      <% end %>
    </h2>
    """
  end

  defp time() do
    DateTime.utc_now() |> to_string
  end

  defp random_number do
    Enum.random(@range)
  end

  def handle_event("guess", %{"number" => guess}, socket) do
    socket =
      if String.to_integer(guess) == socket.assigns.secret do
        assign(socket,
          message: "Your guess: #{guess}. Correct! Congrats! ",
          score: socket.assigns.score + 10,
          won?: true
        )
      else
        assign(socket,
          message: "Your guess: #{guess}. Wrong. Guess again. ",
          score: socket.assigns.score - 1
        )
      end

    {
      :noreply,
      assign(
        socket,
        time: time()
      )
    }
  end
end
