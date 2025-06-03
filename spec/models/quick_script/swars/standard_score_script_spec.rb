require "rails_helper"

RSpec.describe QuickScript::Swars::StandardScoreScript, type: :model do
  def scope
    battles = QuickScript::Swars::StandardScoreScript.mock_setup
    ids = battles.flat_map { |e| e.memberships.pluck(:id) }
    scope = ::Swars::Membership.where(id: ids)
  end

  it "works" do
    QuickScript::Swars::StandardScoreScript.new({}, {scope: scope, batch_limit: 1}).cache_write
    e = QuickScript::Swars::StandardScoreScript.new.aggregate
    assert { e == {"九段": 1, "初段": 2} }
    assert { QuickScript::Swars::StandardScoreScript.new.sd_merged_grade_infos }
  end

  it "in_batches を使ってユニーク人数を求める場合でも整合性が取れている" do
    a = QuickScript::Swars::StandardScoreScript.new({}, {scope: scope, one_shot: true}).aggregate_now
    b = QuickScript::Swars::StandardScoreScript.new({}, {scope: scope, one_shot: false, batch_size: 1}).aggregate_now
    assert { a.values.sum == b.values.sum }
  end
end
