defmodule NaiveDice.TeslaMockAdapter do
  @moduledoc """
  Tesla adapter with all the required mocks
  """

  def call(env, _opts) do
    {:ok, mock(env)}
  end

  def mock(%{method: :post, url: "https://api.stripe.com/v1/checkout/sessions"}),
    do: Tesla.Mock.json(%{"id" => "someid"})

  def mock(%{method: :get, url: "https://api.stripe.com/v1/checkout/sessions/someid" <> _}),
    do: Tesla.Mock.json(%{"payment_intent" => %{"status" => "succeeded"}})
end
