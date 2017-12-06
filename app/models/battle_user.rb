# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 将棋ウォーズユーザーテーブル (battle_users as BattleUser)
#
# |-----------------+-----------------+-------------+-------------+------------------+-------|
# | カラム名        | 意味            | タイプ      | 属性        | 参照             | INDEX |
# |-----------------+-----------------+-------------+-------------+------------------+-------|
# | id              | ID              | integer(8)  | NOT NULL PK |                  |       |
# | unique_key      | Unique key      | string(255) | NOT NULL    |                  | A     |
# | battle_user_key | Battle user key | string(255) | NOT NULL    |                  | B     |
# | battle_rank_id  | Battle rank     | integer(8)  |             | => BattleRank#id | C     |
# | created_at      | 作成日時        | datetime    | NOT NULL    |                  |       |
# | updated_at      | 更新日時        | datetime    | NOT NULL    |                  |       |
# |-----------------+-----------------+-------------+-------------+------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・BattleUser モデルは BattleRank モデルから has_many :battle_users されています。
#--------------------------------------------------------------------------------

class BattleUser < ApplicationRecord
  has_many :battle_ships, dependent: :destroy
  has_many :battle_records, through: :battle_ships
  belongs_to :battle_rank       # すべてのモードの一番よい段位を指す

  before_validation do
    self.unique_key ||= SecureRandom.hex
    self.battle_rank ||= BattleRank.last

    # BattleRank が下がらないようにする
    # 例えば10分メインの人が3分を1回やっただけで30級に戻らないようにする
    if changes[:battle_rank_id]
      ov, nv = changes[:battle_rank_id]
      if ov && nv
        if BattleRank.find(ov).priority < BattleRank.find(nv).priority
          self.battle_rank_id = ov
        end
      end
    end
  end

  with_options presence: true do
    validates :unique_key
    validates :battle_user_key
  end

  with_options allow_blank: true do
    validates :battle_user_key, uniqueness: true
  end

  def to_param
    battle_user_key
  end
end
