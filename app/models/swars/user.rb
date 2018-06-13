# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (users as Swars::User)
#
# |------------------------------------+------------------------------------+-------------+-------------+------------------------+-------|
# | カラム名                           | 意味                               | タイプ      | 属性        | 参照                   | INDEX |
# |------------------------------------+------------------------------------+-------------+-------------+------------------------+-------|
# | id                                 | ID                                 | integer(8)  | NOT NULL PK |                        |       |
# | user_key                           | User key                           | string(255) | NOT NULL    |                        | A!    |
# | grade_id              | Swars battle grade                 | integer(8)  | NOT NULL    | => Swars::Grade#id | B     |
# | last_reception_at                  | Last reception at                  | datetime    |             |                        |       |
# | search_logs_count | Swars battle user receptions count | integer(4)  | DEFAULT(0)  |                        |       |
# | created_at                         | 作成日時                           | datetime    | NOT NULL    |                        |       |
# | updated_at                         | 更新日時                           | datetime    | NOT NULL    |                        |       |
# |------------------------------------+------------------------------------+-------------+-------------+------------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・Swars::User モデルは Swars::Grade モデルから has_many :users されています。
#--------------------------------------------------------------------------------

class Swars::User < ApplicationRecord
  has_many :memberships, dependent: :destroy      # 対局時の情報(複数)
  has_many :battles, through: :memberships # 対局(複数)
  belongs_to :grade                         # すべてのモードのなかで一番よい段級位
  has_many :search_logs, dependent: :destroy   # 明示的に取り込んだ日時の記録

  before_validation do
    self.grade ||= Swars::Grade.last

    # Swars::Grade が下がらないようにする
    # 例えば10分メインの人が3分を1回やっただけで30級に戻らないようにする
    if changes[:grade_id]
      ov, nv = changes[:grade_id]
      if ov && nv
        if Swars::Grade.find(ov).priority < Swars::Grade.find(nv).priority
          self.grade_id = ov
        end
      end
    end
  end

  with_options presence: true do
    validates :user_key
  end

  with_options allow_blank: true do
    validates :user_key, uniqueness: true
  end

  def to_param
    user_key
  end
end
