# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応テーブル (wars_ships as WarsShip)
#
# |----------------+-------------+------------+-------------+------------------+-------|
# | カラム名       | 意味        | タイプ     | 属性        | 参照             | INDEX |
# |----------------+-------------+------------+-------------+------------------+-------|
# | id             | ID          | integer(8) | NOT NULL PK |                  |       |
# | wars_record_id | Wars record | integer(8) |             | => WarsRecord#id | A     |
# | wars_user_id   | Wars user   | integer(8) |             | => WarsUser#id   | B     |
# | wars_rank_id   | Wars rank   | integer(8) |             | => WarsRank#id   | C     |
# | win_flag       | Win flag    | boolean    | NOT NULL    |                  |       |
# | position       | 順序        | integer(4) |             |                  |       |
# | created_at     | 作成日時    | datetime   | NOT NULL    |                  |       |
# | updated_at     | 更新日時    | datetime   | NOT NULL    |                  |       |
# |----------------+-------------+------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・WarsShip モデルは WarsRecord モデルから has_one :wars_ship_black されています。
# ・WarsShip モデルは WarsUser モデルから has_many :wars_ships されています。
# ・WarsShip モデルは WarsRank モデルから has_many :wars_users されています。
#--------------------------------------------------------------------------------

class WarsShip < ApplicationRecord
  belongs_to :wars_record
  belongs_to :wars_user, touch: true
  belongs_to :wars_rank  # 対局したときの段位

  acts_as_list top_of_list: 0, scope: :wars_record

  scope :win_flag_is, -> e { where(win_flag: e) }

  before_validation do
    if wars_user
      self.wars_rank ||= wars_user.wars_rank
    end
  end

  def name_with_rank
    "#{wars_user.user_key} #{wars_rank.name}"
  end
end
