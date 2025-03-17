# -*- coding: utf-8 -*-
# == ShareBoard::Schema ShareBoard::Information ==
#
# ShareBoard::Room (share_board_rooms as ShareBoard::Room)
#
# |---------------------+---------------------+-------------+-------------+------+-------|
# | name                | desc                | type        | opts        | refs | index |
# |---------------------+---------------------+-------------+-------------+------+-------|
# | id                  | ID                  | integer(8)  | NOT NULL PK |      |       |
# | key                 | キー                | string(255) | NOT NULL    |      | A!    |
# | battles_count       | ShareBoard::Battles count       | integer(4)  | DEFAULT(0)  |      |       |
# | created_at          | 作成日時            | datetime    | NOT NULL    |      |       |
# | updated_at          | 更新日時            | datetime    | NOT NULL    |      |       |
# | chat_messages_count | ShareBoard::Chat messages count | integer(4)  | DEFAULT(0)  |      |       |
# |---------------------+---------------------+-------------+-------------+------+-------|

require "rails_helper"

RSpec.describe ShareBoard::Room do
  describe "ランキング" do
    it "works" do
      room = ShareBoard::Room.create!
      room.redis_clear

      2.times do |i|
        room.battles.create! do |e|
          e.memberships.build([
              { user_name: "alice", location_key: "black", judge_key: "win",  },
              { user_name: "bob",   location_key: "white", judge_key: "lose", },
              { user_name: "carol", location_key: "black", judge_key: "win",  },
            ])
        end
      end

      room.reload
      assert { room.roomships.collect(&:rank) === [1, 1, 3] }
      tp room.roomships if $0 == __FILE__
    end
  end

  describe "発言履歴" do
    before do
      ShareBoard.setup
    end

    describe "自分が誰かとして発言する" do
      it "GPTの発言" do
        ShareBoard::Room.simple_say({room_key: "dev_room", message_scope_key: "ms_private", sender_key: "bot", content: "GPTの発言"})
        chat_message = ShareBoard::Room.fetch("dev_room").chat_messages.sole
        assert { chat_message.content == "GPTの発言" }
        assert { chat_message.from_user_name == "GPT" }
        assert { chat_message.primary_emoji == "🤖" }
        assert { chat_message.message_scope_key == "ms_private" }
        assert { chat_message.session_user == ::User.bot }
      end

      it "運営の発言" do
        ShareBoard::Room.simple_say({room_key: "dev_room", message_scope_key: "ms_private", sender_key: "admin", content: "運営の発言"})
        chat_message = ShareBoard::Room.fetch("dev_room").chat_messages.sole
        assert { chat_message.content == "運営の発言" }
        assert { chat_message.from_user_name == "運営" }
        assert { chat_message.primary_emoji == nil }
        assert { chat_message.message_scope_key == "ms_private" }
        assert { chat_message.session_user == ::User.admin }
      end

      it "通常の発言" do
        ShareBoard::Room.simple_say({room_key: "dev_room", message_scope_key: "ms_private", from_user_name: "通常", content: "通常の発言"})
        chat_message = ShareBoard::Room.fetch("dev_room").chat_messages.sole
        assert { chat_message.content == "通常の発言" }
        assert { chat_message.from_user_name == "通常" }
        assert { chat_message.primary_emoji == nil }
        assert { chat_message.message_scope_key == "ms_private" }
        assert { chat_message.session_user == nil }
      end
    end

    describe "GPTに発言を促す" do
      it "DBには入らない発言に応答させる", chat_gpt_spec: true do
        ShareBoard::Room.something_say({room_key: "dev_room", message_scope_key: "ms_private", content: "3.14159 とは何ですか？(漢字三文字で)"})
        chat_message = ShareBoard::Room.fetch("dev_room").chat_messages.sole
        assert { chat_message.content.include?("円周率") }
        assert { chat_message.from_user_name == "GPT" }
        assert { chat_message.primary_emoji == "🤖" }
        assert { chat_message.message_scope_key == "ms_private" }
        assert { chat_message.session_user == ::User.bot }
      end

      it "主に直前の発言に対して応答させる", chat_gpt_spec: true do
        ShareBoard::Room.something_say({room_key: "dev_room", message_scope_key: "ms_private"})
        chat_message = ShareBoard::Room.fetch("dev_room").chat_messages.sole
        assert { chat_message.content.match?(/\p{Hiragana}+/) }
        assert { chat_message.from_user_name == "GPT" }
        assert { chat_message.primary_emoji == "🤖" }
        assert { chat_message.message_scope_key == "ms_private" }
        assert { chat_message.session_user == ::User.bot }
      end
    end
  end
end
