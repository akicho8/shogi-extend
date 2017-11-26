# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応テーブル (war_ships as WarShip)
#
# |----------------+-------------+------------+-------------+------------------+-------|
# | カラム名       | 意味        | タイプ     | 属性        | 参照             | INDEX |
# |----------------+-------------+------------+-------------+------------------+-------|
# | id             | ID          | integer(8) | NOT NULL PK |                  |       |
# | war_record_id | Wars record | integer(8) |             | => WarRecord#id | A     |
# | war_user_id   | Wars user   | integer(8) |             | => WarUser#id   | B     |
# | war_rank_id   | Wars rank   | integer(8) |             | => WarRank#id   | C     |
# | win_flag       | Win flag    | boolean    | NOT NULL    |                  |       |
# | position       | 順序        | integer(4) |             |                  |       |
# | created_at     | 作成日時    | datetime   | NOT NULL    |                  |       |
# | updated_at     | 更新日時    | datetime   | NOT NULL    |                  |       |
# |----------------+-------------+------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・WarShip モデルは WarRecord モデルから has_one :war_ship_black されています。
# ・WarShip モデルは WarUser モデルから has_many :war_ships されています。
# ・WarShip モデルは WarRank モデルから has_many :war_users されています。
#--------------------------------------------------------------------------------

class WarShip < ApplicationRecord
  belongs_to :war_record
  belongs_to :war_user, touch: true
  belongs_to :war_rank  # 対局したときの段位

  acts_as_list top_of_list: 0, scope: :war_record

  scope :win_flag_is, -> e { where(win_flag: e) }

  before_validation do
    if war_user
      self.war_rank ||= war_user.war_rank
    end
  end

  def name_with_rank
    "#{war_user.user_key} #{war_rank.name}"
  end
end
