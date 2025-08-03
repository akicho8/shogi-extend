require "rails_helper"

RSpec.describe QuickScript::Admin::ShareBoardRoomIndexScript, type: :model do
  it "works" do
    ShareBoard::Room.mock
    assert { QuickScript::Admin::ShareBoardRoomIndexScript.new.call }
  end
end
