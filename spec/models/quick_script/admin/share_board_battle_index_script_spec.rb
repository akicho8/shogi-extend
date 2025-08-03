require "rails_helper"

RSpec.describe QuickScript::Admin::ShareBoardBattleSearchScript, type: :model do
  it "works" do
    ShareBoard::Room.mock
    assert { QuickScript::Admin::ShareBoardBattleSearchScript.new.call }
  end
end
