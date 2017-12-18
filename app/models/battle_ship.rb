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

  scope :judge_key_eq, -> v { where(judge_key: v).take }

  # 先手/後手側の対局時の情報
  scope :black, -> { where(location_key: "black").take! }
  scope :white, -> { where(location_key: "white").take! }

  # # 勝者/敗者側の対局時の情報(引き分けの場合ない)
  # scope :win,  -> { judge_key_eq(:win)  }
  # scope :lose, -> { judge_key_eq(:lose) }

  # battle_user に対する自分/相手
  scope :myself, -> battle_user { where(battle_user_id: battle_user.id).take!     }
  scope :rival,  -> battle_user { where.not(battle_user_id: battle_user.id).take! }

  acts_as_ordered_taggable_on :defense_tags
  acts_as_ordered_taggable_on :attack_tags

  before_validation do
    # 無かったときだけ入れる(絶対あるんだけど)
    if battle_user
      self.battle_grade ||= battle_user.battle_grade
    end
  end

  with_options presence: true do
    validates :judge_key
    validates :location_key
  end

  with_options allow_blank: true do
    validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
    validates :battle_user_id, uniqueness: {scope: :battle_record_id}
    validates :location_key, uniqueness: {scope: :battle_record_id}
    validates :location_key, inclusion: Bushido::Location.keys.collect(&:to_s)
  end

  def name_with_grade
    "#{battle_user.uid} #{battle_grade.name}"
  end

  def location
    Bushido::Location.fetch(location_key)
  end
end
