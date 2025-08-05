require "rails_helper"

RSpec.describe QuickScript::Admin::ShareBoardRoomSearchScript, type: :model do
  it "works" do
    room = ShareBoard::Room.mock
    assert { QuickScript::Admin::ShareBoardRoomSearchScript.new(room_id: room.id).call }
    assert { QuickScript::Admin::ShareBoardRoomSearchScript.new(user_id: room.user_ids).call }
  end
end
