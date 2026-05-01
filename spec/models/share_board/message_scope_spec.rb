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
    chat_message = room.chat_messages.create!(user: user)
    assert { ShareBoard::MessageScope[:ms_public].chat_messages == [chat_message] }
  end
end
