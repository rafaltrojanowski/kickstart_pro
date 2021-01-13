defmodule Kickstart.Subscriptions do
  alias Kickstart.Accounts.Subscription
  alias Kickstart.Repo

  def cancel(%Subscription{} = subscription) do
    subscription
    |> Subscription.changeset(%{status: "canceled"})
    |> Repo.update!()
  end
end
