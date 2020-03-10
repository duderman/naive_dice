defmodule Stripe.CheckoutSession.Creator do
  alias Stripe.Item
  alias Stripe.CheckoutSession.Api

  @spec create(%{title: String.t()}, String.t()) ::
          {:error, String.t()} | {:ok, String.t()}
  def create(event = %{title: _title}, callback_url) do
    event
    |> Item.build()
    |> build_payload(callback_url)
    |> Api.create()
    |> parse_response()
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

  defp parse_response(_), do: {:error, "Wrong Stripe response"}
end
