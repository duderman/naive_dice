defmodule Stripe.Item do
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
end
