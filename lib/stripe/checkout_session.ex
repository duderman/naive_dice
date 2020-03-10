defmodule Stripe.CheckoutSession do
  alias Stripe.{Api, Item}

  @spec create(Item.t(), String.t(), String.t()) :: {:ok, String.t()}
  def create(item = %Item{}, success_url, cancel_url) do
    build_payload(item, success_url, cancel_url)
    |> Api.checkout_session()
    |> parse_response
  end

  defp build_payload(item = %Item{}, s, c) do
    item
    |> Map.from_struct()
    |> build_payload(s, c)
  end

  defp build_payload(item, success_url, cancel_url) do
    %{
      payment_method_types: ["card"],
      line_items: [item],
      success_url: success_url,
      cancel_url: cancel_url
    }
  end

  defp parse_response({:ok, %{body: %{"id" => id}}}), do: {:ok, id}

  defp parse_response({:ok, %{body: %{"error" => %{"message" => error_message}}}}),
    do: {:error, error_message}

  defp parse_response(z) do
    IO.inspect(z)
    {:error, "Wrong Stripe response"}
  end
end
