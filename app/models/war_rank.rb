# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Wars rankテーブル (war_ranks as WarRank)
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

class WarRank < ApplicationRecord
  has_many :war_users, dependent: :destroy

  default_scope { order(:priority) }

  with_options presence: true do
    validates :unique_key
  end

  with_options allow_blank: true do
    validates :unique_key, inclusion: StaticWarRankInfo.collect(&:name)
  end

  def static_war_rank_info
    StaticWarRankInfo.fetch(unique_key)
  end

  delegate :name, to: :static_war_rank_info
end
