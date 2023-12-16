require "rails_helper"

RSpec.describe ShareBoard::MessageScope do
  before do
    ShareBoard.setup
  end

  it "発言スコープ種別のレコードがある" do
    assert { ShareBoard::MessageScope.count == 2 }
  end

  it "指定種別に対応するレコードたちを取得できる" do
    user = ShareBoard::User.create!
    room = ShareBoard::Room.create!
    chot_message = room.chot_messages.create!(user: user)
    assert { ShareBoard::MessageScope[:ms_public].chot_messages == [chot_message] }
  end
end
