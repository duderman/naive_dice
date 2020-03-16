defmodule Stripe.CheckoutSession.Api do
  @moduledoc """
  Provides Stripe API requests
  """
  @api_key Application.get_env(:naive_dice, Stripe)[:api_key]

  use Tesla

  plug Tesla.Middleware.BaseUrl, "https://api.stripe.com/v1/checkout/sessions"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.FormUrlencoded
  plug Tesla.Middleware.BasicAuth, username: @api_key

  @spec create(%{} | String.t()) :: Tesla.Env.result()
  def create(payload) when is_map(payload) do
    payload
    |> UriQuery.params()
    |> URI.encode_query()
    |> create()
  end

  def create(payload) do
    post("", payload)
  end

  @spec fetch(String.t()) :: Tesla.Env.result()
  def fetch(id) do
    get(id, query: ["expand[]": "payment_intent"])
  end
end
