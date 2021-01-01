defmodule KickstartWeb.Admin.PricingPlanView do
  use KickstartWeb, :view

  import Torch.TableView
  import Torch.FilterView

  alias Kickstart.Accounts.PricingPlan
  alias Kickstart.Accounts.Feature

  def link_to_feature_fields do
    changeset = PricingPlan.changeset(%PricingPlan{features: [%Feature{}]}, %{})
    form = Phoenix.HTML.FormData.to_form(changeset, [])
    fields = render_to_string(__MODULE__, "feature_fields.html", f: form)
    link "Add Feature", to: "#", "data-template": fields, id: "add_feature"
  end
end
