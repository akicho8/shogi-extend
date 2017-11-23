# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle user rankテーブル (battle_user_ranks as BattleUserRank)
#
# |------------+------------+----------+-------------+------+-------|
# | カラム名   | 意味       | タイプ   | 属性        | 参照 | INDEX |
# |------------+------------+----------+-------------+------+-------|
# | id         | ID         | integer  | NOT NULL PK |      |       |
# | unique_key | Unique key | string   | NOT NULL    |      |       |
# | priority   | Priority   | integer  | NOT NULL    |      |       |
# | created_at | 作成日時   | datetime | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime | NOT NULL    |      |       |
# |------------+------------+----------+-------------+------+-------|

class BattleUserRank < ApplicationRecord
  has_many :battle_users, dependent: :destroy

  default_scope { order(:priority) }

  with_options(presence: true) do
    validates :unique_key
  end

  with_options(allow_blank: true) do
    validates :unique_key, inclusion: StaticBattleUserRankInfo.collect(&:name)
  end

  def static_battle_user_rank_info
    StaticBattleUserRankInfo.fetch(unique_key)
  end

  delegate :name, to: :static_battle_user_rank_info
end
