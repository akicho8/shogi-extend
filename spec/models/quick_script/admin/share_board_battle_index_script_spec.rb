require "rails_helper"

RSpec.describe QuickScript::Admin::ShareBoardBattleIndexScript, type: :model do
  it "works" do
    assert { QuickScript::Admin::ShareBoardBattleIndexScript.new.call }
  end
end
