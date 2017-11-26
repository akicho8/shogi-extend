# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (war_users as WarUser)
#
# |--------------+------------+-------------+-------------+----------------+-------|
# | カラム名     | 意味       | タイプ      | 属性        | 参照           | INDEX |
# |--------------+------------+-------------+-------------+----------------+-------|
# | id           | ID         | integer(8)  | NOT NULL PK |                |       |
# | unique_key   | Unique key | string(255) | NOT NULL    |                |       |
# | user_key     | User key   | string(255) | NOT NULL    |                |       |
# | war_rank_id | Wars rank  | integer(8)  |             | => WarRank#id | A     |
# | created_at   | 作成日時   | datetime    | NOT NULL    |                |       |
# | updated_at   | 更新日時   | datetime    | NOT NULL    |                |       |
# |--------------+------------+-------------+-------------+----------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・WarUser モデルは WarRank モデルから has_many :war_users されています。
#--------------------------------------------------------------------------------

class WarUser < ApplicationRecord
  has_many :war_ships, dependent: :destroy
  has_many :war_records, through: :war_ships
  belongs_to :war_rank         # すべてのモードの一番よい段位を指す

  before_validation do
    self.unique_key ||= SecureRandom.hex
    self.war_rank ||= WarRank.last

    # WarRank が下がらないようにする
    # 例えば10分メインの人が3分を1回やっただけで30級に戻らないようにする
    if changes[:war_rank_id]
      ov, nv = changes[:war_rank_id]
      if ov && nv
        if WarRank.find(ov).priority < WarRank.find(nv).priority
          self.war_rank_id = ov
        end
      end
    end
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
