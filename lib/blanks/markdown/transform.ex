defmodule Blanks.Markdown.Transform do

  import Earmark.Helpers, only: [replace: 3]

  @compact_tags ~w[a code em strong]

  # https://www.w3.org/TR/2011/WD-html-markup-20110113/syntax.html#void-element
  @void_elements ~W(area base br col command embed hr img input keygen link meta param source track wbr)

  @moduledoc """
  Public Interface to functions operating on the AST
  exposed by `Earmark.as_ast`
  """

  @doc """
    Needs update for 1.4.7
  """
  def transform(ast, options \\ %{initial_indent: 0, indent: 2})
  def transform(ast, options) when is_list(options) do
    transform(ast, options|>Enum.into(%{initial_indent: 0, indent: 2}))
  end
  def transform(ast, options) when is_map(options) do
    options1 = options
      |> Map.put_new(:indent, 2)
    to_html(ast, options1)
  end

  # Cloze test transformations
  defp add_cloze_test_blank_attributes(attributes, %{mode: :preview, value: value}) do
    [
      {"value", value},
      {"disabled", "true"},
      {"class", "bg-gray-200 text-gray-300 w-32 px-1 mr-1"},
      {"phx-debounce", "500"}
    ]
    ++ attributes
  end
  defp add_cloze_test_blank_attributes(attributes, %{mode: :results, blank_id: blank_id, fillings: fillings, selected_blank_id: selected_blank_id}) do
    most_chosen_filling = fillings |> Map.get(blank_id, [{"", 1}]) |> Enum.at(0) |> elem(0)
    css_class = "hover:bg-teal-300 text-gray-900 font-semibold w-32 px-1 mr-1 cursor-pointer"
    css_class = if selected_blank_id == blank_id, do: "bg-teal-200 #{css_class}", else: "bg-gray-100 #{css_class}"
    [
      {"class", css_class},
      {"phx-click", "blank-clicked"},
      {"phx-value-blank_id", blank_id},
      {"disabled", "true"},
      {"value", most_chosen_filling}
    ]
    ++ attributes
  end
  defp add_cloze_test_blank_attributes(attributes, _options) do
    [
      {"class", "bg-gray-200 text-gray-900 w-32 px-1 mr-1"},
      {"phx-debounce", "500"}
    ]
    ++ attributes
  end


  defp to_html(ast, options) do
    _to_html(ast, options, Map.get(options, :initial_indent, 0))|> IO.iodata_to_binary
  end

  defp _to_html(ast, options, level, verbatim \\ false)
  defp _to_html({:comment, _, content, _}, _options, _level, _verbatim) do
    "<!--#{content |> Enum.intersperse("\n")}-->\n"
  end
  defp _to_html({"a", atts, children, _}, %{is_cloze_test: true, mode: mode} = options, _level, _verbatim) do
    blank_id = atts |> Enum.into(%{}) |> Map.get("href", "")
    attributes = [
      {"type", "text"},
      {"name", blank_id},
      {"autocomplete", "off"}
    ]
    |> add_cloze_test_blank_attributes(%{
      mode: mode,
      blank_id: blank_id,
      value: Enum.at(children, 0, ""),
      fillings: Map.get(options, :fillings, %{}),
      selected_blank_id: Map.get(options, :selected_blank_id)
    })

    open_tag("input", attributes)
  end
  defp _to_html({tag, atts, children, _}, options, level, verbatim) when tag in @compact_tags do
    [open_tag(tag, atts),
       children
       |> Enum.map(&_to_html(&1, options, level, verbatim)),
       "</#{tag}>"]
  end
  defp _to_html({tag, atts, _, _}, options, level, _verbatim) when tag in @void_elements do
    [ make_indent(options, level), open_tag(tag, atts), "\n" ]
  end
  defp _to_html(elements, options, level, verbatim) when is_list(elements) do
    elements
    |> Enum.map(&_to_html(&1, options, level, verbatim))
  end
  defp _to_html(element, options, _level, false) when is_binary(element) do
    escape(element, options)
  end
  defp _to_html(element, options, level, true) when is_binary(element) do
    [make_indent(options, level), element]
  end
  defp _to_html({"pre", atts, children, meta}, options, level, _verbatim) do
    verbatim = meta |> Map.get(:verbatim, false)
    [ make_indent(options, level),
      open_tag("pre", atts),
      _to_html(children, Map.put(options, :smartypants, false), level, verbatim),
      "</pre>\n"]
  end
  defp _to_html({tag, atts, children, meta}, options, level, _verbatim) do
    verbatim = meta |> Map.get(:verbatim, false)
    [ make_indent(options, level),
      open_tag(tag, atts),
      "\n",
      _to_html(children, options, level+1, verbatim),
      close_tag(tag, options, level)]
  end

  defp close_tag(tag, options, level) do
    [make_indent(options, level), "</", tag, ">\n"]
  end

  defp escape(element, options)
  defp escape("", _opions) do
    []
  end
  defp escape(element, options) do
    element
      |> smartypants(options)
      |> Earmark.Helpers.escape(true)
  end

  defp make_att(name_value_pair, tag)
  defp make_att({name, value}, _) do
    [" ", name, "=\"", value, "\""]
  end

  defp make_indent(%{indent: indent}, level) do
    Stream.cycle([" "])
    |> Enum.take(level*indent)
  end

  defp open_tag(tag, atts)
  defp open_tag(tag, atts) when tag in @void_elements do
    ["<", "#{tag}", Enum.map(atts, &make_att(&1, tag)), " />"]
  end
  defp open_tag(tag, atts) do
    ["<", "#{tag}", Enum.map(atts, &make_att(&1, tag)), ">"]
  end

  @em_dash_rgx ~r{---}
  @en_dash_rgx ~r{--}
  @dbl1_rgx ~r{(^|[-–—/\(\[\{"”“\s])'}
  @single_rgx ~r{\'}
  @dbl2_rgx ~r{(^|[-–—/\(\[\{‘\s])\"}
  @dbl3_rgx ~r{"}
  defp smartypants(text, options)
  defp smartypants(text, %{smartypants: true}) do
    text
    |> replace(@em_dash_rgx, "—")
    |> replace(@en_dash_rgx, "–")
    |> replace(@dbl1_rgx, "\\1‘")
    |> replace(@single_rgx, "’")
    |> replace(@dbl2_rgx, "\\1“")
    |> replace(@dbl3_rgx, "”")
    |> String.replace("...", "…")
  end
  defp smartypants(text, _options), do: text

end
