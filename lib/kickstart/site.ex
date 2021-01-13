defmodule Kickstart.Site do
  @moduledoc """
  The Site context.
  """

  import Ecto.Query, warn: false
  alias Kickstart.Repo

  alias Kickstart.Site.Faq

  @doc """
  Returns the list of faqs.

  ## Examples

      iex> list_faqs()
      [%Faq{}, ...]

  """
  def list_faqs do
    Repo.all(Faq)
  end

  @doc """
  Gets a single faq.

  Raises `Ecto.NoResultsError` if the Faq does not exist.

  ## Examples

      iex> get_faq!(123)
      %Faq{}

      iex> get_faq!(456)
      ** (Ecto.NoResultsError)

  """
  def get_faq!(id), do: Repo.get!(Faq, id)

  @doc """
  Creates a faq.

  ## Examples

      iex> create_faq(%{field: value})
      {:ok, %Faq{}}

      iex> create_faq(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_faq(attrs \\ %{}) do
    %Faq{}
    |> Faq.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a faq.

  ## Examples

      iex> update_faq(faq, %{field: new_value})
      {:ok, %Faq{}}

      iex> update_faq(faq, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_faq(%Faq{} = faq, attrs) do
    faq
    |> Faq.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a faq.

  ## Examples

      iex> delete_faq(faq)
      {:ok, %Faq{}}

      iex> delete_faq(faq)
      {:error, %Ecto.Changeset{}}

  """
  def delete_faq(%Faq{} = faq) do
    Repo.delete(faq)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking faq changes.

  ## Examples

      iex> change_faq(faq)
      %Ecto.Changeset{data: %Faq{}}

  """
  def change_faq(%Faq{} = faq, attrs \\ %{}) do
    Faq.changeset(faq, attrs)
  end

  import Torch.Helpers, only: [sort: 1, paginate: 4]
  import Filtrex.Type.Config

  @pagination [page_size: 15]
  @pagination_distance

  def paginate_faqs(params \\ %{}) do
    params =
      params
      |> Map.put_new("sort_direction", "desc")
      |> Map.put_new("sort_field", "inserted_at")

    {:ok, sort_direction} = Map.fetch(params, "sort_direction")
    {:ok, sort_field} = Map.fetch(params, "sort_field")

    with {:ok, filter} <- Filtrex.parse_params(filter_config(:faqs), params["faq"] || %{}),
         %Scrivener.Page{} = page <- do_paginate_faqs(filter, params) do
      {:ok,
       %{
         faqs: page.entries,
         page_number: page.page_number,
         page_size: page.page_size,
         total_pages: page.total_pages,
         total_entries: page.total_entries,
         distance: @pagination_distance,
         sort_field: sort_field,
         sort_direction: sort_direction
       }}
    else
      {:error, error} -> {:error, error}
      error -> {:error, error}
    end
  end

  defp do_paginate_faqs(filter, params) do
    Faq
    |> Filtrex.query(filter)
    |> order_by(^sort(params))
    |> paginate(Repo, params, @pagination)
  end

  defp filter_config(:faqs) do
    defconfig do
      text(:question)
      text(:answer)
    end
  end
end
