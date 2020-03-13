defmodule NaiveDiceWeb.FallbackController do
  use NaiveDiceWeb, :controller
  alias NaiveDiceWeb.ErrorView

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(ErrorView)
    |> render("404.html")
  end

  def call(conn, {:error, msg}) when is_binary(msg) do
    conn
    |> put_status(500)
    |> put_view(ErrorView)
    |> render("500.html", %{message: msg})
  end
end
