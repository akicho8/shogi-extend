require "rails_helper"

RSpec.describe QuickScript::Admin::ShareBoardRoomSearchScript, type: :model do
  it "works" do
    ShareBoard::Room.mock
    assert { QuickScript::Admin::ShareBoardRoomSearchScript.new.call }
  end
end
