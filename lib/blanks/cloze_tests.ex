defmodule Blanks.ClozeTests do
  @moduledoc """
  The ClozeTests context.
  """

  import Ecto.Query, warn: false
  alias Blanks.Repo

  alias Blanks.ClozeTests.ClozeTest

  @doc """
  Returns the list of cloze_tests.

  ## Examples

      iex> list_cloze_tests()
      [%ClozeTest{}, ...]

  """
  def list_cloze_tests do
    Repo.all(ClozeTest)
  end

  @doc """
  Gets a single cloze_test.

  Raises `Ecto.NoResultsError` if the Cloze test does not exist.

  ## Examples

      iex> get_cloze_test!(123)
      %ClozeTest{}

      iex> get_cloze_test!(456)
      ** (Ecto.NoResultsError)

  """
  def get_cloze_test!(id), do: Repo.get!(ClozeTest, id)

  @doc """
  Creates a cloze_test.

  ## Examples

      iex> create_cloze_test(%{field: value})
      {:ok, %ClozeTest{}}

      iex> create_cloze_test(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_cloze_test(attrs \\ %{}) do
    %ClozeTest{}
    |> ClozeTest.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a cloze_test.

  ## Examples

      iex> update_cloze_test(cloze_test, %{field: new_value})
      {:ok, %ClozeTest{}}

      iex> update_cloze_test(cloze_test, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_cloze_test(%ClozeTest{} = cloze_test, attrs) do
    cloze_test
    |> ClozeTest.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a cloze_test.

  ## Examples

      iex> delete_cloze_test(cloze_test)
      {:ok, %ClozeTest{}}

      iex> delete_cloze_test(cloze_test)
      {:error, %Ecto.Changeset{}}

  """
  def delete_cloze_test(%ClozeTest{} = cloze_test) do
    Repo.delete(cloze_test)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking cloze_test changes.

  ## Examples

      iex> change_cloze_test(cloze_test)
      %Ecto.Changeset{data: %ClozeTest{}}

  """
  def change_cloze_test(%ClozeTest{} = cloze_test, attrs \\ %{}) do
    ClozeTest.changeset(cloze_test, attrs)
  end
end
