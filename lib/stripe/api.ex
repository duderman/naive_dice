defmodule Stripe.Api do
  use Tesla.Builder

  plug Tesla.Middleware.BaseUrl, "https://api.stripe.com/v1"
  plug Tesla.Middleware.JSON
  plug Tesla.Middleware.FormUrlencoded

  @spec checkout_session(any) :: Tesla.Env.result()
  def checkout_session(payload) when is_map(payload) do
    payload
    |> UriQuery.params()
    |> URI.encode_query()
    |> checkout_session()
  end

  def checkout_session(payload) do
    new() |> post("/checkout/sessions", payload)
  end

  defp new do
    Tesla.client([{Tesla.Middleware.BasicAuth, %{username: api_key()}}])
  end

  defp api_key do
    Application.get_env(:naive_dice, Stripe)[:api_key]
  end
end
