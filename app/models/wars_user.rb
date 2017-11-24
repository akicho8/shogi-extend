# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (wars_users as WarsUser)
#
# |--------------+------------+----------+-------------+----------------+-------|
# | カラム名     | 意味       | タイプ   | 属性        | 参照           | INDEX |
# |--------------+------------+----------+-------------+----------------+-------|
# | id           | ID         | integer  | NOT NULL PK |                |       |
# | unique_key   | Unique key | string   | NOT NULL    |                |       |
# | user_key     | User key   | string   | NOT NULL    |                |       |
# | wars_rank_id | Wars rank  | integer  |             | => WarsRank#id | A     |
# | created_at   | 作成日時   | datetime | NOT NULL    |                |       |
# | updated_at   | 更新日時   | datetime | NOT NULL    |                |       |
# |--------------+------------+----------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・WarsUser モデルは WarsRank モデルから has_many :wars_users されています。
#--------------------------------------------------------------------------------

class WarsUser < ApplicationRecord
  has_many :wars_ships, dependent: :destroy
  has_many :wars_records, through: :wars_ships
  belongs_to :wars_rank

  before_validation do
    self.unique_key ||= SecureRandom.hex
    self.wars_rank ||= WarsRank.last
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
