# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応テーブル (battle_ships as BattleShip)
#
# |------------------+---------------+-------------+-------------+--------------------+-------|
# | カラム名         | 意味          | タイプ      | 属性        | 参照               | INDEX |
# |------------------+---------------+-------------+-------------+--------------------+-------|
# | id               | ID            | integer(8)  | NOT NULL PK |                    |       |
# | battle_record_id | Battle record | integer(8)  | NOT NULL    | => BattleRecord#id | A     |
# | battle_user_id   | Battle user   | integer(8)  | NOT NULL    | => BattleUser#id   | B     |
# | battle_grade_id  | Battle grade  | integer(8)  | NOT NULL    | => BattleGrade#id  | C     |
# | judge_key        | Judge key     | string(255) | NOT NULL    |                    | D     |
# | position         | 順序          | integer(4)  |             |                    | E     |
# | created_at       | 作成日時      | datetime    | NOT NULL    |                    |       |
# | updated_at       | 更新日時      | datetime    | NOT NULL    |                    |       |
# |------------------+---------------+-------------+-------------+--------------------+-------|
#
#- 備考 -------------------------------------------------------------------------
# ・BattleShip モデルは BattleRecord モデルから has_one :battle_ship_black されています。
# ・BattleShip モデルは BattleUser モデルから has_many :battle_ships されています。
# ・BattleShip モデルは BattleGrade モデルから has_many :battle_users されています。
#--------------------------------------------------------------------------------

class BattleShip < ApplicationRecord
  belongs_to :battle_record
  belongs_to :battle_user, touch: true
  belongs_to :battle_grade  # 対局したときの段位

  acts_as_list top_of_list: 0, scope: :battle_record

  scope :judge_key_eq, -> v { where(judge_key: v) }

  acts_as_ordered_taggable_on :defense_tags
  acts_as_ordered_taggable_on :attack_tags

  before_validation do
    if battle_user
      self.battle_grade ||= battle_user.battle_grade
    end
  end

  with_options presence: true do
    validates :judge_key
  end

  with_options allow_blank: true do
    validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
  end

  def name_with_rank
    "#{battle_user.uid} #{battle_grade.name}"
  end
end
