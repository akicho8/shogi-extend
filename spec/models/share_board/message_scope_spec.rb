# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Message scope (share_board_message_scopes as ShareBoard::MessageScope)
#
# |------------+----------+-------------+-------------+------+-------|
# | name       | desc     | type        | opts        | refs | index |
# |------------+----------+-------------+-------------+------+-------|
# | id         | ID       | integer(8)  | NOT NULL PK |      |       |
# | key        | キー     | string(255) | NOT NULL    |      | A!    |
# | position   | 順序     | integer(4)  |             |      | B     |
# | created_at | 作成日時 | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時 | datetime    | NOT NULL    |      |       |
# |------------+----------+-------------+-------------+------+-------|

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
