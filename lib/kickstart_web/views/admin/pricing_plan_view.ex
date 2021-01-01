defmodule KickstartWeb.Admin.PricingPlanView do
  use KickstartWeb, :view

  import Torch.TableView
  import Torch.FilterView

  alias Kickstart.Accounts.PricingPlan
  alias Kickstart.Accounts.Feature
end
