defmodule NaiveDiceWeb.CallbackController do
  use NaiveDiceWeb, :controller

  def success(conn, params) do
    json(conn, params)
  end

  def cancel(conn, params) do
    json(conn, params)
  end
end
