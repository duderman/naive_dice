defmodule Stripe.CheckoutSession.Api do
  @moduledoc """
  Provides Stripe API requests
  """
  use Tesla.Builder

  plug Tesla.Middleware.BaseUrl, "https://api.stripe.com/v1/checkout/sessions"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.FormUrlencoded

  @spec create(%{} | String.t()) :: Tesla.Env.result()
  def create(payload) when is_map(payload) do
    payload
    |> UriQuery.params()
    |> URI.encode_query()
    |> create()
  end

  def create(payload) do
    new() |> post("", payload)
  end

  @spec fetch(String.t()) :: Tesla.Env.result()
  def fetch(id) do
    new() |> get(id, query: ["expand[]": "payment_intent"])
  end

  defp new do
    Tesla.client([{Tesla.Middleware.BasicAuth, %{username: api_key()}}])
  end

  defp api_key do
    Application.get_env(:naive_dice, Stripe)[:api_key]
  end
end
