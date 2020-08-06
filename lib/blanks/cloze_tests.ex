defmodule Blanks.ClozeTests do
  @moduledoc """
  The ClozeTests context.
  """

  import Ecto.Query, warn: false
  alias Blanks.Repo

  alias Blanks.ClozeTests.ClozeTest
  alias Blanks.ClozeTests.ClozeTestSubmission

  @doc """
  Returns the list of cloze_tests owned by the user.
  """
  def list_user_cloze_tests(user_id) do
    q = from t in ClozeTest, where: t.user_id == ^user_id, order_by: t.inserted_at
    Repo.all(q)
  end

    @doc """
  Returns the list of cloze_tests owned by the user.
  """
  def get_user_cloze_test(user_id, cloze_test_id) do
    q = from t in ClozeTest, where: t.user_id == ^user_id and t.id == ^cloze_test_id
    Repo.one(q)
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

   @doc """
  Returns an `%Ecto.Changeset{}` for tracking cloze_test_submission changes.
  """
  def change_cloze_test_submission(%ClozeTestSubmission{} = cloze_test_submission, attrs \\ %{}) do
    ClozeTestSubmission.changeset(cloze_test_submission, attrs)
  end

  @doc """
  Creates a cloze_test submission.
  """
  def create_cloze_test_submission(attrs \\ %{}, fillings \\ []) do
    attrs = attrs |> Map.put(:fillings, fillings)
    %ClozeTestSubmission{}
    |> ClozeTestSubmission.changeset(attrs)
    |> Repo.insert()
  end
end
