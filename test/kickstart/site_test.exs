defmodule Kickstart.SiteTest do
  use Kickstart.DataCase

  alias Kickstart.Site

  describe "faqs" do
    alias Kickstart.Site.Faq

    @valid_attrs %{answer: "some answer", question: "some question"}
    @update_attrs %{answer: "some updated answer", question: "some updated question"}
    @invalid_attrs %{answer: nil, question: nil}

    def faq_fixture(attrs \\ %{}) do
      {:ok, faq} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Site.create_faq()

      faq
    end

    test "list_faqs/0 returns all faqs" do
      faq = faq_fixture()
      assert Site.list_faqs() == [faq]
    end

    test "get_faq!/1 returns the faq with given id" do
      faq = faq_fixture()
      assert Site.get_faq!(faq.id) == faq
    end

    test "create_faq/1 with valid data creates a faq" do
      assert {:ok, %Faq{} = faq} = Site.create_faq(@valid_attrs)
      assert faq.answer == "some answer"
      assert faq.question == "some question"
    end

    test "create_faq/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Site.create_faq(@invalid_attrs)
    end

    test "update_faq/2 with valid data updates the faq" do
      faq = faq_fixture()
      assert {:ok, %Faq{} = faq} = Site.update_faq(faq, @update_attrs)
      assert faq.answer == "some updated answer"
      assert faq.question == "some updated question"
    end

    test "update_faq/2 with invalid data returns error changeset" do
      faq = faq_fixture()
      assert {:error, %Ecto.Changeset{}} = Site.update_faq(faq, @invalid_attrs)
      assert faq == Site.get_faq!(faq.id)
    end

    test "delete_faq/1 deletes the faq" do
      faq = faq_fixture()
      assert {:ok, %Faq{}} = Site.delete_faq(faq)
      assert_raise Ecto.NoResultsError, fn -> Site.get_faq!(faq.id) end
    end

    test "change_faq/1 returns a faq changeset" do
      faq = faq_fixture()
      assert %Ecto.Changeset{} = Site.change_faq(faq)
    end
  end
end
