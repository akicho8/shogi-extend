require "rails_helper"

RSpec.describe QuickScript::Swars::RuleWiseWinRateScript, type: :model do
  it "works" do
    ::Swars::Battle.create!(imode_key: "スプリント")
    QuickScript::Swars::RuleWiseWinRateScript.new.cache_write

    object = QuickScript::Swars::RuleWiseWinRateScript.new
    assert { object.sprintha_gotegatuyoi_noka.call }
    assert { object.grade_each_sprint_win_rate.call }
  end
end
