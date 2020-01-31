# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |-------------------+--------------------+--------------+-------------+-----------------------------------+-------|
# | name              | desc               | type         | opts        | refs                              | index |
# |-------------------+--------------------+--------------+-------------+-----------------------------------+-------|
# | id                | ID                 | integer(8)   | NOT NULL PK |                                   |       |
# | key               | ユニークなハッシュ | string(255)  | NOT NULL    |                                   | A!    |
# | kifu_url          | 棋譜URL            | string(255)  |             |                                   |       |
# | kifu_body         | 棋譜               | text(65535)  | NOT NULL    |                                   |       |
# | turn_max          | 手数               | integer(4)   | NOT NULL    |                                   | D     |
# | meta_info         | 棋譜ヘッダー       | text(65535)  | NOT NULL    |                                   |       |
# | battled_at        | Battled at         | datetime     | NOT NULL    |                                   | C     |
# | created_at        | 作成日時           | datetime     | NOT NULL    |                                   |       |
# | updated_at        | 更新日時           | datetime     | NOT NULL    |                                   |       |
# | colosseum_user_id | 所有者ID           | integer(8)   |             | :owner_user => Colosseum::User#id | B     |
# | title             | 題名               | string(255)  |             |                                   |       |
# | description       | 説明               | text(65535)  | NOT NULL    |                                   |       |
# | start_turn        | 開始局面           | integer(4)   |             |                                   |       |
# | critical_turn     | 開戦               | integer(4)   |             |                                   | E     |
# | saturn_key        | 公開範囲           | string(255)  | NOT NULL    |                                   | F     |
# | sfen_body         | SFEN形式棋譜       | string(8192) |             |                                   |       |
# | image_turn        | OGP画像の局面      | integer(4)   |             |                                   |       |
# | use_key           | Use key            | string(255)  | NOT NULL    |                                   |       |
# |-------------------+--------------------+--------------+-------------+-----------------------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :free_battles, foreign_key: :colosseum_user_id
#--------------------------------------------------------------------------------

require 'rails_helper'

RSpec.describe FreeBattle, type: :model do
  before do
    tempfile = Tempfile.open
    tempfile.write("68S")
    @kifu_file = ActionDispatch::Http::UploadedFile.new(filename: "嬉野流.kif", type: "text/plain", tempfile: tempfile.open)
  end

  it "ファイルアップロードして変換" do
    free_battle = FreeBattle.create!(kifu_file: @kifu_file)
    assert { free_battle.kifu_body == "68S" }
  end

  it "「**解析」などが含まれる巨大なKIFはいったん綺麗にする" do
    free_battle = FreeBattle.create!(kifu_body: <<~EOT)
手数----指手---------消費時間--
**Engines 0 HoneyWaffle WCSC28
**解析
*一致率 先手 21% = 14/64  後手 40% = 26/64
*棋戦詳細：ライバル対決
   1 ５六歩(57)        ( 0:00/00:00:00)
**解析
**候補手
EOT

    assert { free_battle.kifu_body == <<~EOT }
手数----指手---------消費時間--
*一致率 先手 21% = 14/64  後手 40% = 26/64
*棋戦詳細：ライバル対決
   1 ５六歩(57)        ( 0:00/00:00:00)
EOT
  end
end
