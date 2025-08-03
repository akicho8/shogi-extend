require "rails_helper"

RSpec.describe QuickScript::Admin::DashboardScript, type: :model do
  it "works" do
    assert { QuickScript::Admin::DashboardScript.new.prepare_aggregation_cache }
    assert { QuickScript::Admin::DashboardScript.new.call }
  end
end
