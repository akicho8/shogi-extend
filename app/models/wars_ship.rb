# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応テーブル (wars_ships as WarsShip)
#
# |----------------+-------------+----------+-------------+------------------+-------|
# | カラム名       | 意味        | タイプ   | 属性        | 参照             | INDEX |
# |----------------+-------------+----------+-------------+------------------+-------|
# | id             | ID          | integer  | NOT NULL PK |                  |       |
# | wars_record_id | Wars record | integer  |             | => WarsRecord#id | C     |
# | wars_user_id   | Wars user   | integer  |             | => WarsUser#id   | B     |
# | wars_rank_id   | Wars rank   | integer  |             | => WarsRank#id   | A     |
# | position       | 順序        | integer  |             |                  |       |
# | created_at     | 作成日時    | datetime | NOT NULL    |                  |       |
# | updated_at     | 更新日時    | datetime | NOT NULL    |                  |       |
# |----------------+-------------+----------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・WarsShip モデルは WarsRecord モデルから has_many :wars_ships されています。
# ・WarsShip モデルは WarsUser モデルから has_many :wars_ships されています。
# ・WarsShip モデルは WarsRank モデルから has_many :wars_users されています。
#--------------------------------------------------------------------------------

class WarsShip < ApplicationRecord
  belongs_to :wars_record
  belongs_to :wars_user
  belongs_to :wars_rank  # 対局したときの段位

  acts_as_list top_of_list: 0, scope: :wars_record
  default_scope { order(:position) }

  before_validation do
    if wars_user
      self.wars_rank ||= wars_user.wars_rank
    end
  end

  def name_with_rank
    "#{wars_user.user_key} #{wars_rank.name}"
  end
end
