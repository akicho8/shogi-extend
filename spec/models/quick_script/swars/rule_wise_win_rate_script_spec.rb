require "rails_helper"

RSpec.describe QuickScript::Swars::RuleWiseWinRateScript, type: :model do
  it "works" do
    ::Swars::Battle.create!(imode_key: "スプリント", rule_key: "3分")
    obj = QuickScript::Swars::RuleWiseWinRateScript.new
    obj.cache_write
    assert { obj.as_general_json }
    assert { obj.as_json }
  end
end
