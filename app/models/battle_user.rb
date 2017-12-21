# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (battle_users as BattleUser)
#
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
# | カラム名              | 意味                  | タイプ      | 属性        | 参照              | INDEX |
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
# | id                    | ID                    | integer(8)  | NOT NULL PK |                   |       |
# | uid                   | Uid                   | string(255) | NOT NULL    |                   | A!    |
# | battle_grade_id       | Battle grade          | integer(8)  | NOT NULL    | => BattleGrade#id | B     |
# | last_reception_at     | Last reception at     | datetime    |             |                   |       |
# | user_receptions_count | User receptions count | integer(4)  | DEFAULT(0)  |                   |       |
# | created_at            | 作成日時              | datetime    | NOT NULL    |                   |       |
# | updated_at            | 更新日時              | datetime    | NOT NULL    |                   |       |
# |-----------------------+-----------------------+-------------+-------------+-------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・BattleUser モデルは BattleGrade モデルから has_many :battle_users されています。
#--------------------------------------------------------------------------------

class BattleUser < ApplicationRecord
  has_many :battle_ships, dependent: :destroy      # 対局時の情報(複数)
  has_many :battle_records, through: :battle_ships # 対局(複数)
  belongs_to :battle_grade                         # すべてのモードのなかで一番よい段級位
  has_many :user_receptions, dependent: :destroy   # 明示的に取り込んだ日時の記録

  before_validation do
    self.battle_grade ||= BattleGrade.last

    # BattleGrade が下がらないようにする
    # 例えば10分メインの人が3分を1回やっただけで30級に戻らないようにする
    if changes[:battle_grade_id]
      ov, nv = changes[:battle_grade_id]
      if ov && nv
        if BattleGrade.find(ov).priority < BattleGrade.find(nv).priority
          self.battle_grade_id = ov
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
