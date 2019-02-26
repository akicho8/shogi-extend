# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜入力 (free_battles as FreeBattle)
#
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | name              | desc               | type        | opts        | refs                              | index |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)  | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255) | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255) |             |                                   |       |
# | kifu_body         | 棋譜               | text(65535) | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)  | NOT NULL    |                                   |       |
# | meta_info         | 棋譜ヘッダー       | text(65535) | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime    | NOT NULL    |                                   |       |
# | created_at        | 作成日時           | datetime    | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime    | NOT NULL    |                                   |       |
# | colosseum_user_id | Colosseum user     | integer(8)  |             | :owner_user => Colosseum::User#id | B     |
# | title             | タイトル           | string(255) |             |                                   |       |
# |-------------------+--------------------+-------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# 【警告:リレーション欠如】Colosseum::Userモデルで has_many :free_battles, :foreign_key => :colosseum_user_id されていません
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe FreeBattle, type: :model do
  before do
    @kifu_file = {io: StringIO.new("68S"), filename: "嬉野流.kif", content_type: "application/octet-stream"}
  end

  it "ファイルアップロードして変換" do
    free_battle = FreeBattle.create!(kifu_file: @kifu_file)
    assert { free_battle.kifu_body == "68S" }
    assert { free_battle.kifu_file.attached? == false }
  end
end
