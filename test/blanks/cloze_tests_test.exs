defmodule Blanks.ClozeTestsTest do
  use Blanks.DataCase

  alias Blanks.ClozeTests

  describe "cloze_tests" do
    alias Blanks.ClozeTests.ClozeTest

    @valid_attrs %{content: "some content", name: "some name"}
    @update_attrs %{content: "some updated content", name: "some updated name"}
    @invalid_attrs %{content: nil, name: nil}

    def cloze_test_fixture(attrs \\ %{}) do
      {:ok, cloze_test} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ClozeTests.create_cloze_test()

      cloze_test
    end

    test "list_cloze_tests/0 returns all cloze_tests" do
      cloze_test = cloze_test_fixture()
      assert ClozeTests.list_cloze_tests() == [cloze_test]
    end

    test "get_cloze_test!/1 returns the cloze_test with given id" do
      cloze_test = cloze_test_fixture()
      assert ClozeTests.get_cloze_test!(cloze_test.id) == cloze_test
    end

    test "create_cloze_test/1 with valid data creates a cloze_test" do
      assert {:ok, %ClozeTest{} = cloze_test} = ClozeTests.create_cloze_test(@valid_attrs)
      assert cloze_test.content == "some content"
      assert cloze_test.name == "some name"
    end

    test "create_cloze_test/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ClozeTests.create_cloze_test(@invalid_attrs)
    end

    test "update_cloze_test/2 with valid data updates the cloze_test" do
      cloze_test = cloze_test_fixture()
      assert {:ok, %ClozeTest{} = cloze_test} = ClozeTests.update_cloze_test(cloze_test, @update_attrs)
      assert cloze_test.content == "some updated content"
      assert cloze_test.name == "some updated name"
    end

    test "update_cloze_test/2 with invalid data returns error changeset" do
      cloze_test = cloze_test_fixture()
      assert {:error, %Ecto.Changeset{}} = ClozeTests.update_cloze_test(cloze_test, @invalid_attrs)
      assert cloze_test == ClozeTests.get_cloze_test!(cloze_test.id)
    end

    test "delete_cloze_test/1 deletes the cloze_test" do
      cloze_test = cloze_test_fixture()
      assert {:ok, %ClozeTest{}} = ClozeTests.delete_cloze_test(cloze_test)
      assert_raise Ecto.NoResultsError, fn -> ClozeTests.get_cloze_test!(cloze_test.id) end
    end

    test "change_cloze_test/1 returns a cloze_test changeset" do
      cloze_test = cloze_test_fixture()
      assert %Ecto.Changeset{} = ClozeTests.change_cloze_test(cloze_test)
    end
  end
end
