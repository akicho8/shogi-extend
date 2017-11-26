# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応テーブル (battle_ships as BattleShip)
#
# |------------------+---------------+------------+-------------+--------------------+-------|
# | カラム名         | 意味          | タイプ     | 属性        | 参照               | INDEX |
# |------------------+---------------+------------+-------------+--------------------+-------|
# | id               | ID            | integer(8) | NOT NULL PK |                    |       |
# | battle_record_id | Battle record | integer(8) |             | => BattleRecord#id | A     |
# | battle_user_id   | Battle user   | integer(8) |             | => BattleUser#id   | B     |
# | battle_rank_id   | Battle rank   | integer(8) |             | => BattleRank#id   | C     |
# | win_flag         | Win flag      | boolean    | NOT NULL    |                    |       |
# | position         | 順序          | integer(4) |             |                    |       |
# | created_at       | 作成日時      | datetime   | NOT NULL    |                    |       |
# | updated_at       | 更新日時      | datetime   | NOT NULL    |                    |       |
# |------------------+---------------+------------+-------------+--------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・BattleShip モデルは BattleRecord モデルから has_one :battle_ship_black されています。
# ・BattleShip モデルは BattleUser モデルから has_many :battle_ships されています。
# ・BattleShip モデルは BattleRank モデルから has_many :battle_users されています。
#--------------------------------------------------------------------------------

class BattleShip < ApplicationRecord
  belongs_to :battle_record
  belongs_to :battle_user, touch: true
  belongs_to :battle_rank  # 対局したときの段位

  acts_as_list top_of_list: 0, scope: :battle_record

  scope :win_flag_is, -> e { where(win_flag: e) }

  before_validation do
    if battle_user
      self.battle_rank ||= battle_user.battle_rank
    end
  end

  def name_with_rank
    "#{battle_user.user_key} #{battle_rank.name}"
  end
end
