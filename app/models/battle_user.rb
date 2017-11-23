# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 棋譜変換テーブル (battle_users as BattleUser)
#
# |---------------------+--------------------+----------+-------------+----------------------+-------|
# | カラム名            | 意味               | タイプ   | 属性        | 参照                 | INDEX |
# |---------------------+--------------------+----------+-------------+----------------------+-------|
# | id                  | ID                 | integer  | NOT NULL PK |                      |       |
# | unique_key          | ユニークなハッシュ | string   | NOT NULL    |                      |       |
# | user_key            | User key           | string   | NOT NULL    |                      |       |
# | battle_user_rank_id | Battle user rank   | integer  |             | => BattleUserRank#id | A     |
# | created_at          | 作成日時           | datetime | NOT NULL    |                      |       |
# | updated_at          | 更新日時           | datetime | NOT NULL    |                      |       |
# |---------------------+--------------------+----------+-------------+----------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・BattleUser モデルは BattleUserRank モデルから has_many :battle_users されています。
#--------------------------------------------------------------------------------

class BattleUser < ApplicationRecord
  has_many :battle_ships, dependent: :destroy
  has_many :battle_records, through: :battle_ships
  belongs_to :battle_user_rank

  before_validation do
    self.unique_key ||= SecureRandom.hex
    self.battle_user_rank ||= BattleUserRank.last
  end

  with_options presence: true do
    validates :unique_key
    validates :user_key
  end

  with_options allow_blank: true do
    validates :user_key, uniqueness: true
  end

  def to_param
    user_key
  end
end
