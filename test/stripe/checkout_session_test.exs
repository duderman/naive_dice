defmodule Stripe.CheckoutSessionTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import Tesla.Mock
  alias Stripe.{CheckoutSession, Item}

  @item %Item{name: "item", amount: 50}

  describe "Stripe.CheckoutSession.create/3" do
    test "with correct stripe response" do
      mock(fn
        %{method: :post, url: "https://api.stripe.com/v1/checkout/session"} ->
          json(%{"id" => "someid"})
      end)

      assert CheckoutSession.create(@item, "success_url", "cancel_url") ==
               {:ok, %CheckoutSession{id: "someid"}}
    end

    test "calls Stripe with correct payload" do
      mock(fn %{body: json_body} ->
        {:ok, body} = Jason.decode(json_body)

        assert %{
                 "success_url" => "success_url",
                 "cancel_url" => "cancel_url",
                 "payment_method_types" => ["card"],
                 "line_items" => [
                   %{
                     "name" => "item",
                     "amount" => 50,
                     "currency" => "gbp",
                     "description" => "",
                     "images" => [],
                     "quantity" => 1
                   }
                 ]
               } == body
      end)

      CheckoutSession.create(@item, "success_url", "cancel_url")
    end

    test "calls Stripe with correct auth info" do
      mock(fn %{headers: headers} ->
        auth = Base.encode64("STRIPE_API_KEY:")
        assert {"authorization", "Basic " <> auth} in headers
      end)

      CheckoutSession.create(@item, "success_url", "cancel_url")
    end
  end
end
