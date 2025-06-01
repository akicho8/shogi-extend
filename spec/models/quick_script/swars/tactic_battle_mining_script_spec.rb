require "rails_helper"

RSpec.describe QuickScript::Swars::TacticBattleMiningScript, type: :model do
  it "works" do
    user1 = Swars::User.create!
    user2 = Swars::User.create!
    battle = ::Swars::Battle.create_with_members!([user1, user2], {strike_plan: "棒銀"})
    ids = [battle].flat_map { |e| e.memberships.pluck(:id) }
    scope = Swars::Membership.where(id: ids)
    QuickScript::Swars::TacticBattleMiningScript.new({}, {scope: scope, item_keys: ["棒銀"], need_size: 1}).cache_write
    tp QuickScript::Swars::TacticBattleMiningScript.new.aggregate if $0 == __FILE__
    assert { QuickScript::Swars::TacticBattleMiningScript.new.aggregate[:"棒銀"] == [battle.id] }
  end
end
