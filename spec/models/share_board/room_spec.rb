require "rails_helper"

RSpec.describe ShareBoard::Room do
  describe "発言履歴" do
    before do
      ShareBoard.setup
    end

    describe "自分が誰かとして発言する" do
      it "GPTの発言" do
        ShareBoard::Room.simple_say({ room_key: "test_room", message_scope_key: "ms_private", sender_key: "bot", content: "GPTの発言" })
        chat_message = ShareBoard::Room.fetch("test_room").chat_messages.sole
        assert { chat_message.content == "GPTの発言" }
        assert { chat_message.from_user_name == "GPT" }
        assert { chat_message.primary_emoji == "🤖" }
        assert { chat_message.message_scope_key == "ms_private" }
        assert { chat_message.session_user == ::User.bot }
      end

      it "運営の発言" do
        ShareBoard::Room.simple_say({ room_key: "test_room", message_scope_key: "ms_private", sender_key: "admin", content: "運営の発言" })
        chat_message = ShareBoard::Room.fetch("test_room").chat_messages.sole
        assert { chat_message.content == "運営の発言" }
        assert { chat_message.from_user_name == "運営" }
        assert { chat_message.primary_emoji == nil }
        assert { chat_message.message_scope_key == "ms_private" }
        assert { chat_message.session_user == ::User.admin }
      end

      it "通常の発言" do
        ShareBoard::Room.simple_say({ room_key: "test_room", message_scope_key: "ms_private", from_user_name: "通常", content: "通常の発言" })
        chat_message = ShareBoard::Room.fetch("test_room").chat_messages.sole
        assert { chat_message.content == "通常の発言" }
        assert { chat_message.from_user_name == "通常" }
        assert { chat_message.primary_emoji == nil }
        assert { chat_message.message_scope_key == "ms_private" }
        assert { chat_message.session_user == nil }
      end
    end

    describe "GPTに発言を促す" do
      it "DBには入らない発言に応答させる", ai_active: true do
        ShareBoard::Room.something_say({ room_key: "test_room", message_scope_key: "ms_private", content: "3.14159 とは何ですか？(漢字三文字で)" })
        chat_message = ShareBoard::Room.fetch("test_room").chat_messages.sole
        assert { chat_message.content.include?("円周率") }
        assert { chat_message.from_user_name == "GPT" }
        assert { chat_message.primary_emoji == "🤖" }
        assert { chat_message.message_scope_key == "ms_private" }
        assert { chat_message.session_user == ::User.bot }
      end

      it "主に直前の発言に対して応答させる", ai_active: true do
        ShareBoard::Room.something_say({ room_key: "test_room", message_scope_key: "ms_private" })
        chat_message = ShareBoard::Room.fetch("test_room").chat_messages.sole
        assert { chat_message.content.match?(/\p{Hiragana}+/) }
        assert { chat_message.from_user_name == "GPT" }
        assert { chat_message.primary_emoji == "🤖" }
        assert { chat_message.message_scope_key == "ms_private" }
        assert { chat_message.session_user == ::User.bot }
      end
    end
  end
end
