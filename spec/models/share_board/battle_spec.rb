# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Battle (share_board_battles as ShareBoard::Battle)
#
# |-----------------+--------------+-------------+-------------+----------------+-------|
# | name            | desc         | type        | opts        | refs           | index |
# |-----------------+--------------+-------------+-------------+----------------+-------|
# | id              | ID           | integer(8)  | NOT NULL PK |                |       |
# | room_id         | Room         | integer(8)  | NOT NULL    |                | B     |
# | key             | キー         | string(255) | NOT NULL    |                | A!    |
# | title           | タイトル     | string(255) | NOT NULL    |                |       |
# | sfen            | Sfen         | text(65535) | NOT NULL    |                |       |
# | turn            | Turn         | integer(4)  | NOT NULL    |                | C     |
# | win_location_id | Win location | integer(8)  | NOT NULL    | => Location#id | D     |
# | position        | 順序         | integer(4)  |             |                | E     |
# | created_at      | 作成日時     | datetime    | NOT NULL    |                |       |
# | updated_at      | 更新日時     | datetime    | NOT NULL    |                |       |
# |-----------------+--------------+-------------+-------------+----------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# 【警告:リレーション欠如】Locationモデルで has_many :share_board/battles されていません
# --------------------------------------------------------------------------------

require "rails_helper"

RSpec.describe ShareBoard::Battle, type: :model do
  it "works" do
    room = ShareBoard::Room.mock
    battle = room.battles.first
    assert { battle.black.collect { |e| e.user.name } == ["alice", "carol"] }
    assert { battle.white.collect { |e| e.user.name } == ["bob"] }
  end
end
