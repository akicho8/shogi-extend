require "rails_helper"

RSpec.describe QuickScript::Swars::TacticJudgeAggregator, type: :model do
  it "works" do
    QuickScript::Swars::TacticJudgeAggregator.mock_setup
    QuickScript::Swars::TacticJudgeAggregator.new.cache_write
    assert { QuickScript::Swars::TacticJudgeAggregator.new.aggregate }
    assert { QuickScript::Swars::TacticJudgeAggregator.new.tactics_hash[:"原始棒銀"] }
  end
end
