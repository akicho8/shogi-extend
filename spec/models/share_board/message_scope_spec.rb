require "rails_helper"

module ShareBoard
  RSpec.describe MessageScope do
    before do
      ShareBoard.setup
    end

    it "発言スコープ種別のレコードがある" do
      assert { MessageScope.count == 2 }
    end

    it "指定種別に対応するレコードたちを取得できる" do
      user = User.create!
      room = Room.create!
      chat_message = room.chat_messages.create!(user: user)
      assert { MessageScope[:ms_public].chat_messages == [chat_message] }
    end
  end
end
