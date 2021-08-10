defmodule Mastery.Application do
  @moduledoc false

  use Application
  alias Mastery.Boundary.QuizManager

  @impl Application
  def start(_type, _args) do
    IO.puts "Starting Mastery"

    children = [
      QuizManager,
      {Registry, [name: Mastery.Registry.QuizSession, keys: :unique]},
      {DynamicSupervisor, [name: Mastery.Supervisor.QuizSession, strategy: :one_for_one]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mastery.Supervisor]
    Supervisor.start_link(children, opts)
  end

end
