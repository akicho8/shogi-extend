# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Chat message (share_board_chat_messages as ShareBoard::ChatMessage)
#
# |--------------------+-----------------+-------------+-------------+--------------+-------|
# | name               | desc            | type        | opts        | refs         | index |
# |--------------------+-----------------+-------------+-------------+--------------+-------|
# | id                 | ID              | integer(8)  | NOT NULL PK |              |       |
# | room_id            | Room            | integer(8)  | NOT NULL    |              | A     |
# | user_id            | User            | integer(8)  | NOT NULL    | => User#id   | B     |
# | message_scope_id   | Message scope   | integer(8)  | NOT NULL    |              | C     |
# | content            | Content         | string(256) | NOT NULL    |              |       |
# | performed_at       | Performed at    | integer(8)  | NOT NULL    |              |       |
# | created_at         | 作成日時        | datetime    | NOT NULL    |              |       |
# | updated_at         | 更新日時        | datetime    | NOT NULL    |              |       |
# | session_user_id    | Session user    | integer(8)  |             | => ::User#id | D     |
# | from_connection_id | From connection | string(255) |             |              |       |
# | primary_emoji      | Primary emoji   | string(255) |             |              |       |
# |--------------------+-----------------+-------------+-------------+--------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# User.has_many :share_board_chat_messages, foreign_key: :session_user_id
# User.has_one :profile
# [Warning: Need to add index] create_share_board_chat_messages マイグレーションに add_index :share_board_chat_messages, :from_connection_id を追加しよう
# [Warning: Need to add relation] ShareBoard::ChatMessage モデルに belongs_to :from_connection を追加しよう
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe ShareBoard::ChatMessage do
  before do
    ShareBoard.setup
  end

  it "レコードを作る" do
    user = ShareBoard::User.create!
    room = ShareBoard::Room.create!
    chat_message = room.chat_messages.create!(user: user)
    assert { chat_message.user == user }
    assert { chat_message.room == room }
    chat_message.save!
    assert { room.chat_messages_count == 1 }
    assert { user.chat_messages_count == 1 }
    assert { room.chat_messages == [chat_message] }
    assert { room.chat_users == [user] }
    assert { chat_message.message_scope == ShareBoard::MessageScope[:ms_public] }
  end

  it "user 側のリレーションが正しい" do
    user = ShareBoard::User.create!
    room = ShareBoard::Room.create!
    assert { user.chat_messages.create!(room: room) }
  end

  it "ログインしている人のIDを一緒に記録し削除時は session_user_id を nil にして発言を残す" do
    session_user = ::User.create!
    user = ShareBoard::User.create!
    room = ShareBoard::Room.create!
    chat_message = room.chat_messages.create!(user: user, session_user: session_user)
    assert { chat_message.session_user == session_user }
    assert { session_user.share_board_chat_messages == [chat_message] }
    session_user.destroy!
    chat_message.reload
    assert { chat_message.session_user == nil }
  end

  it "簡単にデータを用意する" do
    user = ShareBoard::User.create!
    room = ShareBoard::Room.create!
    room.setup_for_test(count: 10, user: user, force: true)
    assert { room.chat_messages.count == 10 }
  end

  it "256文字を超える文字はカットする" do
    user = ShareBoard::User.create!
    room = ShareBoard::Room.create!
    chat_message = room.chat_messages.create!(user: user, content: "a" * 256.next)
    assert { chat_message.content.size == 256 }
  end

  it "削除対象のレコードに絞る" do
    user = ShareBoard::User.create!
    room = ShareBoard::Room.create!
    chat_message = room.chat_messages.create!(user: user)
    assert { ShareBoard::ChatMessage.old_only(0).count == 0 }
    assert { Timecop.freeze("2000-01-02") { ShareBoard::ChatMessage.old_only(0).count } == 1 }
  end
end
