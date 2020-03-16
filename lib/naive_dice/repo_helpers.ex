defmodule NaiveDice.RepoHelpers do
  @moduledoc """
  Helper methods for Repo queries
  """

  @spec get_result(any) :: {:error, :not_found} | {:ok, any}
  def get_result(nil), do: {:error, :not_found}
  def get_result(obj), do: {:ok, obj}
end
