# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+--------------------+----------------+-------------+------------+-------|
# | name          | desc               | type           | opts        | refs       | index |
# |---------------+--------------------+----------------+-------------+------------+-------|
# | id            | ID                 | integer(8)     | NOT NULL PK |            |       |
# | key           | ユニークなハッシュ | string(255)    | NOT NULL    |            | A!    |
# | kifu_url      | 棋譜URL            | string(255)    |             |            |       |
# | kifu_body     | 棋譜               | text(16777215) | NOT NULL    |            |       |
# | turn_max      | 手数               | integer(4)     | NOT NULL    |            | E     |
# | meta_info     | 棋譜ヘッダー       | text(65535)    | NOT NULL    |            |       |
# | battled_at    | Battled at         | datetime       | NOT NULL    |            | D     |
# | outbreak_turn | Outbreak turn      | integer(4)     |             |            | B     |
# | use_key       | Use key            | string(255)    | NOT NULL    |            | C     |
# | accessed_at   | Accessed at        | datetime       | NOT NULL    |            |       |
# | created_at    | 作成日時           | datetime       | NOT NULL    |            |       |
# | updated_at    | 更新日時           | datetime       | NOT NULL    |            |       |
# | user_id       | User               | integer(8)     |             | => User#id | I     |
# | title         | タイトル           | string(255)    |             |            |       |
# | description   | 説明               | text(65535)    | NOT NULL    |            |       |
# | start_turn    | 開始局面           | integer(4)     |             |            | F     |
# | critical_turn | 開戦               | integer(4)     |             |            | G     |
# | saturn_key    | 公開範囲           | string(255)    | NOT NULL    |            | H     |
# | sfen_body     | SFEN形式棋譜       | string(8192)   | NOT NULL    |            |       |
# | image_turn    | OGP画像の局面      | integer(4)     |             |            |       |
# | preset_key    | Preset key         | string(255)    | NOT NULL    |            |       |
# | sfen_hash     | Sfen hash          | string(255)    | NOT NULL    |            |       |
# |---------------+--------------------+----------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

class AddCriticalTurnToFreeBattles < ActiveRecord::Migration[5.2]
  def change
    [:swars_battles, :free_battles].each do |table|
      change_table table do |t|
        t.change :start_turn, :integer, null: true
        t.integer :critical_turn, null: true
      end
    end

    Swars::Battle.where(start_turn: 0).update_all(start_turn: nil)
  end
end
