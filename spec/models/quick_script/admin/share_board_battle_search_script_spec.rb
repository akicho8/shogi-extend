require "rails_helper"

RSpec.describe QuickScript::Admin::ShareBoardBattleSearchScript, type: :model do
  it "works" do
    room = ShareBoard::Room.mock
    assert { QuickScript::Admin::ShareBoardBattleSearchScript.new(room_id: room.id).call }
    assert { QuickScript::Admin::ShareBoardBattleSearchScript.new(user_id: room.user_ids).call }
  end
end
