require "rails_helper"

RSpec.describe QuickScript::Swars::TacticListScript, type: :model do
  it "works" do
    Swars::Battle.create!(strike_plan: "原始棒銀")
    QuickScript::Swars::TacticBattleMiningScript.new.cache_write
    QuickScript::Swars::TacticJudgeAggregator.new.cache_write

    instance = QuickScript::Swars::TacticListScript.new
    assert { instance.as_json }
    assert { instance.as_general_json }

    assert { QuickScript::Swars::TacticListScript.new(query: "戦法 アヒ -裏").current_items.collect(&:name) == ["アヒル戦法"] }
  end
end
