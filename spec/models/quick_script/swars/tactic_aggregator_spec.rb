require "rails_helper"

RSpec.describe QuickScript::Swars::TacticAggregator, type: :model do
  it "works" do
    QuickScript::Swars::TacticAggregator.mock_setup
    QuickScript::Swars::TacticAggregator.new.cache_write
    assert { QuickScript::Swars::TacticAggregator.new.aggregate }
    assert { QuickScript::Swars::TacticAggregator.new.exta_hash[:"原始棒銀"] }
  end
end
