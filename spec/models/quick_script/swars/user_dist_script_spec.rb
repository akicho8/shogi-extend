require "rails_helper"

RSpec.describe QuickScript::Swars::UserDistScript, type: :model do
  def scope
    battles = QuickScript::Swars::UserDistScript.mock_setup
    ids = battles.flat_map { |e| e.memberships.pluck(:id) }
    scope = ::Swars::Membership.where(id: ids)
  end

  it "works" do
    QuickScript::Swars::UserDistScript.new({}, { scope: scope, batch_limit: 1 }).cache_write
    e = QuickScript::Swars::UserDistScript.new.aggregate
    assert { e == { "normal/野良/ten_min/九段": 1, "normal/野良/ten_min/初段": 2 } }
  end

  it "in_batches を使ってユニーク人数を求める場合でも整合性が取れている" do
    a = QuickScript::Swars::UserDistScript.new({}, { scope: scope, one_shot: true }).aggregate_now
    b = QuickScript::Swars::UserDistScript.new({}, { scope: scope, one_shot: false, batch_size: 1 }).aggregate_now
    assert { a.values.sum == b.values.sum }
  end
end
