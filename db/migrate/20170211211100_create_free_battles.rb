# -*- coding: utf-8 -*-

# == Schema Information ==
#
# 棋譜投稿 (free_battles as FreeBattle)
#
# |---------------+---------------+----------------+-------------+--------------+-------|
# | name          | desc          | type           | opts        | refs         | index |
# |---------------+---------------+----------------+-------------+--------------+-------|
# | id            | ID            | integer(8)     | NOT NULL PK |              |       |
# | key           | キー          | string(255)    | NOT NULL    |              | A!    |
# | kifu_body     | 棋譜          | text(65535)    |             |              |       |
# | turn_max      | 手数          | integer(4)     | NOT NULL    |              | C     |
# | meta_info     | 棋譜ヘッダー  | text(16777215) | NOT NULL    |              |       |
# | battled_at    | Battled at    | datetime       | NOT NULL    |              | B     |
# | created_at    | 作成日時      | datetime       | NOT NULL    |              |       |
# | updated_at    | 更新日時      | datetime       | NOT NULL    |              |       |
# | user_id       | User          | integer(8)     |             | => User#id   | H     |
# | title         | タイトル      | string(255)    |             |              |       |
# | description   | 説明          | text(65535)    | NOT NULL    |              |       |
# | start_turn    | 開始局面      | integer(4)     |             |              |       |
# | critical_turn | 開戦          | integer(4)     |             |              | D     |
# | saturn_key    | Saturn key    | string(255)    | NOT NULL    |              | E     |
# | sfen_body     | SFEN形式棋譜  | text(65535)    | NOT NULL    |              |       |
# | image_turn    | OGP画像の局面 | integer(4)     |             |              |       |
# | use_key       | Use key       | string(255)    | NOT NULL    |              | G     |
# | outbreak_turn | Outbreak turn | integer(4)     |             |              | F     |
# | accessed_at   | 参照日時      | datetime       | NOT NULL    |              | I     |
# | sfen_hash     | Sfen hash     | string(255)    | NOT NULL    |              |       |
# | preset_id     | Preset        | integer(8)     |             | => Preset#id | J     |
# |---------------+---------------+----------------+-------------+--------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# Preset.has_many :swars_battles
# User.has_one :profile
# --------------------------------------------------------------------------------

class CreateFreeBattles < ActiveRecord::Migration[5.1]
  def up
    create_table :free_battles, force: true do |t|
      t.string :key,            null: false, index: { unique: true }, charset: 'utf8', collation: 'utf8_bin', comment: "URL識別子"
      t.string :kifu_url,       null: true,                                                                 comment: "入力した棋譜URL"
      t.string :title,          null: true
      t.text :kifu_body,        null: false, limit: 65535,                                               comment: "棋譜本文"
      t.text :sfen_body,        null: false, limit: 65535,                                               comment: "SFEN形式"
      t.integer :turn_max,      null: false, index: true,                                                   comment: "手数"
      t.text :meta_info,        null: false,                                                                comment: "棋譜メタ情報"
      t.datetime :battled_at,   null: false, index: true,                                                   comment: "対局開始日時"
      t.string :use_key,        null: false, index: true
      t.datetime :accessed_at,  null: false, index: true, comment: "最終参照日時"
      t.belongs_to :user,       null: true, index: true
      t.string :preset_key,     null: false, index: true
      t.text :description,      null: false
      t.string :sfen_hash,      null: false

      t.integer :start_turn,    null: true, index: true, comment: "???"
      t.integer :critical_turn, null: true, index: true, comment: "開戦"
      t.integer :outbreak_turn, null: true, index: true, comment: "中盤"
      t.integer :image_turn,    null: true,              comment: "???"

      t.timestamps              null: false
    end
  end
end
