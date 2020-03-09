defmodule Stripe.Item do
  @derive Jason.Encoder
  defstruct [:name, :amount, description: "", images: [], currency: "gbp", quantity: 1]

  @type t :: %Stripe.Item{
          name: String.t(),
          description: String.t(),
          images: Array.t(),
          amount: integer,
          currency: String.t(),
          quantity: integer
        }
end
