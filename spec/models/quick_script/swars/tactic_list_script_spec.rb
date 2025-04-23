require "rails_helper"

RSpec.describe QuickScript::Swars::TacticListScript, type: :model do
  it "works" do
    Swars::Battle.create!(strike_plan: "原始棒銀")
    QuickScript::Swars::TacticBattleAggregator.new.cache_write
    QuickScript::Swars::TacticJudgeAggregator.new.cache_write

    instance = QuickScript::Swars::TacticListScript.new
    assert { instance.as_json }
    assert { instance.table_rows }
  end
end
