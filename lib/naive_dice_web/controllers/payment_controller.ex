defmodule NaiveDiceWeb.PaymentController do
  use NaiveDiceWeb, :controller

  def process(conn, params) do
    json(conn, params)
  end
end
