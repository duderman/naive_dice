defmodule Stripe.CheckoutSession do
  alias Stripe.{Api, Item}

  defstruct [:id]

  @type t :: %__MODULE__{id: String.t()}

  @spec create(Item.t(), String.t(), String.t()) :: {:ok, __MODULE__.t()}
  def create(item = %Item{}, success_url, cancel_url) do
    build_payload(item, success_url, cancel_url)
    |> Api.checkout_session()
    |> parse_response
  end

  defp build_payload(item, success_url, cancel_url) do
    %{
      payment_method_types: ["card"],
      line_items: [item],
      success_url: success_url,
      cancel_url: cancel_url
    }
  end

  defp parse_response({:ok, %{body: %{"id" => id}}}), do: {:ok, %__MODULE__{id: id}}
  defp parse_response(_), do: {:error, "Wrong Stripe response"}
end
