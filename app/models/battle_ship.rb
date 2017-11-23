# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle shipテーブル (battle_ships as BattleShip)
#
# |------------------+---------------+----------+-------------+--------------------+-------|
# | カラム名         | 意味          | タイプ   | 属性        | 参照               | INDEX |
# |------------------+---------------+----------+-------------+--------------------+-------|
# | id               | ID            | integer  | NOT NULL PK |                    |       |
# | battle_user_id   | Battle user   | integer  |             | => BattleUser#id   | B     |
# | battle_record_id | Battle record | integer  |             | => BattleRecord#id | A     |
# | position         | 順序          | integer  |             |                    |       |
# | created_at       | 作成日時      | datetime | NOT NULL    |                    |       |
# | updated_at       | 更新日時      | datetime | NOT NULL    |                    |       |
# |------------------+---------------+----------+-------------+--------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・BattleShip モデルは BattleUser モデルから has_many :battle_ships されています。
# ・BattleShip モデルは BattleRecord モデルから has_many :battle_ships されています。
#--------------------------------------------------------------------------------

class BattleShip < ApplicationRecord
  belongs_to :battle_record
  belongs_to :battle_user
  belongs_to :battle_user_rank  # 対局したときの段位

  acts_as_list top_of_list: 0
  default_scope { order(:position) }

  before_validation do
    if battle_user
      self.battle_user_rank ||= battle_user.battle_user_rank
    end
  end

  def name_with_rank
    "#{battle_user.user_key} #{battle_user_rank.name}"
  end
end
