# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle rankテーブル (battle_ranks as BattleRank)
#
# |------------+------------+-------------+-------------+------+-------|
# | カラム名   | 意味       | タイプ      | 属性        | 参照 | INDEX |
# |------------+------------+-------------+-------------+------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |      |       |
# | unique_key | Unique key | string(255) | NOT NULL    |      |       |
# | priority   | Priority   | integer(4)  | NOT NULL    |      |       |
# | created_at | 作成日時   | datetime    | NOT NULL    |      |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |      |       |
# |------------+------------+-------------+-------------+------+-------|

class BattleRank < ApplicationRecord
  has_many :battle_users, dependent: :destroy

  default_scope { order(:priority) }

  with_options presence: true do
    validates :unique_key
  end

  with_options allow_blank: true do
    validates :unique_key, inclusion: StaticBattleRankInfo.collect(&:name)
  end

  def static_battle_rank_info
    StaticBattleRankInfo.fetch(unique_key)
  end

  delegate :name, to: :static_battle_rank_info
end
