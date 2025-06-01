require "rails_helper"

RSpec.describe QuickScript::Swars::PresetBattleMiningScript, type: :model do
  it "works" do
    user1 = Swars::User.create!
    user2 = Swars::User.create!
    battle = ::Swars::Battle.create_with_members!([user1, user2])
    ids = [battle].flat_map { |e| e.memberships.pluck(:id) }
    scope = Swars::Membership.where(id: ids)
    QuickScript::Swars::PresetBattleMiningScript.new({}, {scope: scope, need_size: 1}).cache_write
    tp QuickScript::Swars::PresetBattleMiningScript.new.aggregate if $0 == __FILE__
    assert { QuickScript::Swars::PresetBattleMiningScript.new.aggregate[:"平手"] == [battle.id] }
  end
end
