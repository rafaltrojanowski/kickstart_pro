defmodule KickstartWeb.PostView do
  use KickstartWeb, :view

  # TODO: Get rid of duplication (see LayoutView)
  def gravatar(email) do
    hash =
      email
      |> String.trim()
      |> String.downcase()
      |> :erlang.md5()
      |> Base.encode16(case: :lower)

    img = "https://www.gravatar.com/avatar/#{hash}?s=150&d=identicon"

    img_tag(img,
      class: "img-fluid avatar avatar-ex-sm rounded-pill mr-3 shadow",
      width: "40",
      height: "40"
    )
  end

  def format_datetime(%NaiveDateTime{
        day: day,
        month: month,
        year: year,
        hour: hour,
        minute: minute
      }) do
    "#{format_month(month)} #{format_day(day)}, #{year}"
  end

  defp format_day(day) when day < 10, do: "0#{day}"
  defp format_day(day), do: "#{day}"

  defp format_month(1), do: "January"
  defp format_month(2), do: "February"
  defp format_month(3), do: "March"
  defp format_month(4), do: "April"
  defp format_month(5), do: "May"
  defp format_month(6), do: "June"
  defp format_month(7), do: "July"
  defp format_month(8), do: "August"
  defp format_month(9), do: "September"
  defp format_month(10), do: "October"
  defp format_month(11), do: "November"
  defp format_month(12), do: "December"
end
