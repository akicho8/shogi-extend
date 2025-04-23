require "rails_helper"

RSpec.describe QuickScript::Swars::TacticBattleAggregator, type: :model do
  it "works" do
    QuickScript::Swars::TacticBattleAggregator.mock_setup
    QuickScript::Swars::TacticBattleAggregator.new.cache_write
    assert { QuickScript::Swars::TacticBattleAggregator.new.aggregate[:"原始棒銀"].size == 1 }
  end
end
