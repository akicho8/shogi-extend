# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応テーブル (general_battle_ships as GeneralBattleShip)
#
# |--------------------------+-----------------------+-------------+-------------+---------------------------+-------|
# | カラム名                 | 意味                  | タイプ      | 属性        | 参照                      | INDEX |
# |--------------------------+-----------------------+-------------+-------------+---------------------------+-------|
# | id                       | ID                    | integer(8)  | NOT NULL PK |                           |       |
# | general_battle_record_id | General battle record | integer(8)  | NOT NULL    | => GeneralBattleRecord#id | A! B  |
# | judge_key                | Judge key             | string(255) | NOT NULL    |                           | C     |
# | location_key             | Location key          | string(255) | NOT NULL    |                           | A! D  |
# | position                 | 順序                  | integer(4)  |             |                           | E     |
# | created_at               | 作成日時              | datetime    | NOT NULL    |                           |       |
# | updated_at               | 更新日時              | datetime    | NOT NULL    |                           |       |
# |--------------------------+-----------------------+-------------+-------------+---------------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・GeneralBattleShip モデルは GeneralBattleRecord モデルから has_many :general_battle_ships されています。
#--------------------------------------------------------------------------------

class GeneralBattleShip < ApplicationRecord
  belongs_to :general_battle_record            # 対局

  acts_as_list top_of_list: 0, scope: :general_battle_record

  scope :judge_key_eq, -> v { where(judge_key: v).take }

  # 先手/後手側の対局時の情報
  scope :black, -> { where(location_key: "black").take! }
  scope :white, -> { where(location_key: "white").take! }

  acts_as_ordered_taggable_on :defense_tags
  acts_as_ordered_taggable_on :attack_tags

  with_options presence: true do
    validates :judge_key
    validates :location_key
  end

  with_options allow_blank: true do
    validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
    validates :location_key, uniqueness: {scope: :general_battle_record_id}
    validates :location_key, inclusion: Bushido::Location.keys.collect(&:to_s)
  end

  def location
    Bushido::Location.fetch(location_key)
  end
end
