defmodule Stripe.CheckoutSession.StatusChecker do
  @moduledoc """
  Checks Stripe checkout session through their API
  """

  alias Stripe.CheckoutSession.Api

  @spec check(String.t()) :: {:ok, String.t()} | {:error, String.t()}
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
