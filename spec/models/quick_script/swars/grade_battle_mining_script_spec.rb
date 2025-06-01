require "rails_helper"

RSpec.describe QuickScript::Swars::GradeBattleMiningScript, type: :model do
  it "works" do
    user1 = Swars::User.create!(grade_key: "九段")
    user2 = Swars::User.create!(grade_key: "八段")
    battle = ::Swars::Battle.create_with_members!([user1, user2])
    ids = [battle].flat_map { |e| e.memberships.pluck(:id) }
    scope = Swars::Membership.where(id: ids)
    QuickScript::Swars::GradeBattleMiningScript.new({}, { scope: scope, grade_keys: ["九段"], need_size: 1 }).cache_write
    assert { QuickScript::Swars::GradeBattleMiningScript.new.aggregate[:"九段"] == [battle.id] }
  end
end
