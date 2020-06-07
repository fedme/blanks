defmodule BlanksWeb.ClozeTestLiveTest do
  use BlanksWeb.ConnCase

  import Phoenix.LiveViewTest

  alias Blanks.ClozeTests

  @create_attrs %{content: "some content", name: "some name"}
  @update_attrs %{content: "some updated content", name: "some updated name"}
  @invalid_attrs %{content: nil, name: nil}

  defp fixture(:cloze_test) do
    {:ok, cloze_test} = ClozeTests.create_cloze_test(@create_attrs)
    cloze_test
  end

  defp create_cloze_test(_) do
    cloze_test = fixture(:cloze_test)
    %{cloze_test: cloze_test}
  end

  describe "Index" do
    setup [:create_cloze_test]

    test "lists all cloze_tests", %{conn: conn, cloze_test: cloze_test} do
      {:ok, _index_live, html} = live(conn, Routes.cloze_test_index_path(conn, :index))

      assert html =~ "Listing Cloze tests"
      assert html =~ cloze_test.content
    end

    test "saves new cloze_test", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.cloze_test_index_path(conn, :index))

      assert index_live |> element("a", "New Cloze test") |> render_click() =~
               "New Cloze test"

      assert_patch(index_live, Routes.cloze_test_index_path(conn, :new))

      assert index_live
             |> form("#cloze_test-form", cloze_test: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#cloze_test-form", cloze_test: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.cloze_test_index_path(conn, :index))

      assert html =~ "Cloze test created successfully"
      assert html =~ "some content"
    end

    test "updates cloze_test in listing", %{conn: conn, cloze_test: cloze_test} do
      {:ok, index_live, _html} = live(conn, Routes.cloze_test_index_path(conn, :index))

      assert index_live |> element("#cloze_test-#{cloze_test.id} a", "Edit") |> render_click() =~
               "Edit Cloze test"

      assert_patch(index_live, Routes.cloze_test_index_path(conn, :edit, cloze_test))

      assert index_live
             |> form("#cloze_test-form", cloze_test: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#cloze_test-form", cloze_test: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.cloze_test_index_path(conn, :index))

      assert html =~ "Cloze test updated successfully"
      assert html =~ "some updated content"
    end

    test "deletes cloze_test in listing", %{conn: conn, cloze_test: cloze_test} do
      {:ok, index_live, _html} = live(conn, Routes.cloze_test_index_path(conn, :index))

      assert index_live |> element("#cloze_test-#{cloze_test.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#cloze_test-#{cloze_test.id}")
    end
  end

  describe "Show" do
    setup [:create_cloze_test]

    test "displays cloze_test", %{conn: conn, cloze_test: cloze_test} do
      {:ok, _show_live, html} = live(conn, Routes.cloze_test_show_path(conn, :show, cloze_test))

      assert html =~ "Show Cloze test"
      assert html =~ cloze_test.content
    end

    test "updates cloze_test within modal", %{conn: conn, cloze_test: cloze_test} do
      {:ok, show_live, _html} = live(conn, Routes.cloze_test_show_path(conn, :show, cloze_test))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Cloze test"

      assert_patch(show_live, Routes.cloze_test_show_path(conn, :edit, cloze_test))

      assert show_live
             |> form("#cloze_test-form", cloze_test: @invalid_attrs)
             |> render_change() =~ "can&apos;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#cloze_test-form", cloze_test: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.cloze_test_show_path(conn, :show, cloze_test))

      assert html =~ "Cloze test updated successfully"
      assert html =~ "some updated content"
    end
  end
end
