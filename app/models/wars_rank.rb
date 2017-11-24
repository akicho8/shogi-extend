# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Wars rankテーブル (wars_ranks as WarsRank)
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

class WarsRank < ApplicationRecord
  has_many :wars_users, dependent: :destroy

  default_scope { order(:priority) }

  with_options presence: true do
    validates :unique_key
  end

  with_options allow_blank: true do
    validates :unique_key, inclusion: StaticWarsRankInfo.collect(&:name)
  end

  def static_wars_rank_info
    StaticWarsRankInfo.fetch(unique_key)
  end

  delegate :name, to: :static_wars_rank_info
end
