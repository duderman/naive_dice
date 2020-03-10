defmodule Stripe.CheckoutSession.StatusChecker do
  alias Stripe.CheckoutSession.Api

  def check(id) do
    id
    |> Api.fetch()
    |> parse_response()
  end

  defp parse_response({:ok, %{body: %{"payment_intent" => %{"status" => status}}}}),
    do: {:ok, status}

  defp parse_response({:ok, %{body: %{"error" => %{"message" => error_message}}}}),
    do: {:error, error_message}

  defp parse_response(_), do: {:error, "Wrong Stripe response"}
end
