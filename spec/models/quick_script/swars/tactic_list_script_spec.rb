require "rails_helper"

RSpec.describe QuickScript::Swars::TacticListScript, type: :model do
  it "works" do
    Swars::Battle.create!(strike_plan: "原始棒銀")
    QuickScript::Swars::TacticBattleAggregator.new.cache_write
    QuickScript::Swars::TacticJudgeAggregator.new.cache_write

    instance = QuickScript::Swars::TacticListScript.new
    assert { instance.as_json }
    assert { instance.table_rows }

    assert { QuickScript::Swars::TacticListScript.new(query: "戦法 アヒ -裏").current_items.collect(&:name) == ["アヒル戦法"] }

    json = QuickScript::Swars::TacticListScript.new(json_type: "general").as_json
    assert { json.kind_of? Array }
  end
end
