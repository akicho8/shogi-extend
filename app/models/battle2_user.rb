# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (battle2_users as Battle2User)
#
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
# | カラム名              | 意味                  | タイプ      | 属性        | 参照              | INDEX |
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
# | id                    | ID                    | integer(8)  | NOT NULL PK |                   |       |
# | uid                   | Uid                   | string(255) | NOT NULL    |                   | A!    |
# | battle2_grade_id       | Battle2 grade          | integer(8)  | NOT NULL    | => Battle2Grade#id | B     |
# | last_reception_at     | Last reception at     | datetime    |             |                   |       |
# | user_receptions_count | User receptions count | integer(4)  | DEFAULT(0)  |                   |       |
# | created_at            | 作成日時              | datetime    | NOT NULL    |                   |       |
# | updated_at            | 更新日時              | datetime    | NOT NULL    |                   |       |
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・Battle2User モデルは Battle2Grade モデルから has_many :battle2_users されています。
#--------------------------------------------------------------------------------

class Battle2User < ApplicationRecord
  has_many :battle2_ships, dependent: :destroy      # 対局時の情報(複数)
  has_many :battle2_records, through: :battle2_ships # 対局(複数)
  belongs_to :battle2_grade                         # すべてのモードのなかで一番よい段級位
  has_many :battle2_user_receptions, dependent: :destroy   # 明示的に取り込んだ日時の記録

  before_validation do
    self.battle2_grade ||= Battle2Grade.last

    # Battle2Grade が下がらないようにする
    # 例えば10分メインの人が3分を1回やっただけで30級に戻らないようにする
    if changes[:battle2_grade_id]
      ov, nv = changes[:battle2_grade_id]
      if ov && nv
        if Battle2Grade.find(ov).priority < Battle2Grade.find(nv).priority
          self.battle2_grade_id = ov
        end
      end
    end
  end

  with_options presence: true do
    validates :uid
  end

  with_options allow_blank: true do
    validates :uid, uniqueness: true
  end

  def to_param
    uid
  end
end
