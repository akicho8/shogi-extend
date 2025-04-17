require "rails_helper"

RSpec.describe QuickScript::Swars::TacticStatScript::PrimaryAggregator, type: :model do
  it "works" do
    QuickScript::Swars::TacticStatScript::PrimaryAggregator.mock_setup
    assert { QuickScript::Swars::TacticStatScript::PrimaryAggregator.new.call[:period_based_agg][:day60][:population_count] == 2 }
  end
end
