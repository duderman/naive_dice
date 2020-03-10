defmodule NaiveDice.RepoHelpers do
  def get_result(nil), do: {:error, :not_found}
  def get_result(obj), do: {:ok, obj}

  def to_changeset(obj, attrs) do
    obj.__struct__.changeset(obj, attrs)
  end
end
