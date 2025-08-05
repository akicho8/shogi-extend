require "rails_helper"

RSpec.describe ShareBoard::Battle, type: :model do
  it "works" do
    room = ShareBoard::Room.mock
    battle = room.battles.first
    assert { battle.black.collect { |e| e.user.name } == ["alice", "carol"] }
    assert { battle.white.collect { |e| e.user.name } == ["bob"] }
  end
end
