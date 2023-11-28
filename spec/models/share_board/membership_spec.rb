require "rails_helper"

RSpec.describe ShareBoard::Membership do
  it "user_id は battle_id 内で固有であるバリデーションが効いている" do
    room = ShareBoard::Room.create!
    battle = room.battles.create!
    membership = battle.memberships.create(user_name: "alice", location_key: "black", judge_key: "lose")
    membership = battle.memberships.create(user_name: "alice", location_key: "black", judge_key: "lose")
    assert { membership.errors[:user_id] }
  end
end
