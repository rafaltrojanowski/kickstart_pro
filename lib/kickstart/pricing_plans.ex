defmodule Kickstart.PricingPlans do

  alias Kickstart.Accounts.Feature

  def change_feature(%Feature{} = feature) do
    Feature.changeset(feature, %{})
  end

end
