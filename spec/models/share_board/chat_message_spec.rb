require "rails_helper"

module ShareBoard
  RSpec.describe ShareBoard::ChatMessage do
    before do
      ShareBoard.setup
    end

    it "レコードを作る" do
      user = User.create!
      room = Room.create!
      chat_message = room.chat_messages.create!(user: user)
      assert { chat_message.user == user }
      assert { chat_message.room == room }
      chat_message.save!
      assert { room.chat_messages_count == 1 }
      assert { user.chat_messages_count == 1 }
      assert { room.chat_messages == [chat_message] }
      assert { room.chat_users == [user] }
      assert { chat_message.message_scope == MessageScope[:ms_public] }
    end

    it "user 側のリレーションが正しい" do
      user = User.create!
      room = Room.create!
      assert { user.chat_messages.create!(room: room) }
    end

    it "ログインしている人のIDを一緒に記録し削除時は session_user_id を nil にして発言を残す" do
      session_user = ::User.create!
      user = User.create!
      room = Room.create!
      chat_message = room.chat_messages.create!(user: user, session_user: session_user)
      assert { chat_message.session_user == session_user }
      assert { session_user.share_board_chat_messages == [chat_message] }
      session_user.destroy!
      chat_message.reload
      assert { chat_message.session_user == nil }
    end

    it "簡単にデータを用意する" do
      user = User.create!
      room = Room.create!
      room.setup_for_test(count: 10, user: user, force: true)
      assert { room.chat_messages.count == 10 }
    end

    it "256文字を超える文字はカットする" do
      user = User.create!
      room = Room.create!
      chat_message = room.chat_messages.create!(user: user, content: "a" * 256.next)
      assert { chat_message.content.size == 256 }
    end
  end
end
