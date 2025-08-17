require "rails_helper"

RSpec.describe QuickScript::Swars::TacticListScript, type: :model do
  it "works" do
    Swars::Battle.create!(strike_plan: "アヒル戦法")
    Swars::Battle.create!(strike_plan: "裏アヒル戦法")
    QuickScript::Swars::TacticBattleMiningScript.new.cache_write
    QuickScript::Swars::TacticStatScript.new.cache_write

    instance = QuickScript::Swars::TacticListScript.new
    assert { instance.as_json }
    assert { instance.as_general_json }

    assert { QuickScript::Swars::TacticListScript.new(query: "戦法 アヒ -裏").current_items.collect(&:name) == ["アヒル戦法"] }

    count = QuickScript::Swars::TacticListScript.new.current_items.size
    all_count = QuickScript::Swars::TacticListScript.new(all: "true").current_items.size
    assert { count < all_count }
  end
end
