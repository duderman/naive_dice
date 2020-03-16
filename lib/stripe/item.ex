defmodule Stripe.Item do
  @moduledoc """
  Represents Stripe APIs line item
  """
  defstruct [:name, :amount, currency: "gbp", quantity: 1]

  @type t :: %Stripe.Item{
          name: String.t(),
          amount: integer,
          currency: String.t(),
          quantity: integer
        }

  @spec build(%{title: String.t()}) :: __MODULE__.t()
  def build(%{title: title}) do
    %__MODULE__{name: title, amount: 500}
  end

  defimpl Enumerable, for: __MODULE__ do
    def count(item) do
      item |> to_map |> Enumerable.count()
    end

    def member?(item, opts) do
      item |> to_map |> Enumerable.member?(opts)
    end

    def slice(item) do
      item |> to_map |> Enumerable.slice()
    end

    def reduce(item, acc, fun) do
      item |> to_map |> Enumerable.reduce(acc, fun)
    end

    defp to_map(item) do
      Map.from_struct(item)
    end
  end
end
