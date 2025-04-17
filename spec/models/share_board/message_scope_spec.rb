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

# == ShareBoard::Schema ShareBoard::Information ==
#
# ShareBoard::Message scope (share_board_message_scopes as ShareBoard::MessageScope)
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
