defmodule Stripe.CheckoutSession do
  alias Stripe.{Api, Item}

  @spec create(Item.t() | %{title: String.t()}, String.t()) ::
          {:error, String.t()} | {:ok, String.t()}
  def create(item = %Item{}, callback_url) do
    item
    |> build_payload(callback_url)
    |> Api.checkout_session()
    |> parse_response()
  end

  def create(event = %{title: _title}, callback_url) do
    event
    |> Item.build()
    |> create(callback_url)
  end

  defp build_payload(item = %Item{}, s) do
    item
    |> Map.from_struct()
    |> build_payload(s)
  end

  defp build_payload(item, callback_url) do
    %{
      payment_method_types: ["card"],
      line_items: [item],
      success_url: callback_url,
      cancel_url: callback_url
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
