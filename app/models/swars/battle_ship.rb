# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応テーブル (battle_ships as Swars::BattleShip)
#
# |------------------------+---------------------+-------------+-------------+-------------------------+---------|
# | カラム名               | 意味                | タイプ      | 属性        | 参照                    | INDEX   |
# |------------------------+---------------------+-------------+-------------+-------------------------+---------|
# | id                     | ID                  | integer(8)  | NOT NULL PK |                         |         |
# | battle_record_id | Swars battle record | integer(8)  | NOT NULL    | => Swars::BattleRecord#id | A! B! C |
# | user_id   | Swars battle user   | integer(8)  | NOT NULL    | => Swars::User#id   | B! D    |
# | battle_grade_id  | Swars battle grade  | integer(8)  | NOT NULL    | => Swars::BattleGrade#id  | E       |
# | judge_key              | Judge key           | string(255) | NOT NULL    |                         | F       |
# | location_key           | Location key        | string(255) | NOT NULL    |                         | A! G    |
# | position               | 順序                | integer(4)  |             |                         | H       |
# | created_at             | 作成日時            | datetime    | NOT NULL    |                         |         |
# | updated_at             | 更新日時            | datetime    | NOT NULL    |                         |         |
# |------------------------+---------------------+-------------+-------------+-------------------------+---------|
#
#- 備考 -------------------------------------------------------------------------
# ・Swars::BattleShip モデルは Swars::BattleRecord モデルから has_many :battle_ships されています。
# ・Swars::BattleShip モデルは Swars::User モデルから has_many :battle_ships されています。
# ・Swars::BattleShip モデルは Swars::BattleGrade モデルから has_many :users されています。
#--------------------------------------------------------------------------------

class Swars::BattleShip < ApplicationRecord
  belongs_to :battle_record            # 対局
  belongs_to :user, touch: true # 対局者
  belongs_to :battle_grade             # 対局したときの段位

  acts_as_list top_of_list: 0, scope: :battle_record

  scope :judge_key_eq, -> v { where(judge_key: v).take }

  # 先手/後手側の対局時の情報
  scope :black, -> { where(location_key: "black").take! }
  scope :white, -> { where(location_key: "white").take! }

  # # 勝者/敗者側の対局時の情報(引き分けの場合ない)
  # scope :win,  -> { judge_key_eq(:win)  }
  # scope :lose, -> { judge_key_eq(:lose) }

  # user に対する自分/相手
  scope :myself, -> user { where(user_id: user.id).take!     }
  scope :rival,  -> user { where.not(user_id: user.id).take! }

  acts_as_ordered_taggable_on :defense_tags
  acts_as_ordered_taggable_on :attack_tags

  before_validation do
    # 無かったときだけ入れる(絶対あるんだけど)
    if user
      self.battle_grade ||= user.battle_grade
    end
  end

  with_options presence: true do
    validates :judge_key
    validates :location_key
  end

  with_options allow_blank: true do
    validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
    validates :user_id, uniqueness: {scope: :battle_record_id}
    validates :location_key, uniqueness: {scope: :battle_record_id}
    validates :location_key, inclusion: Warabi::Location.keys.collect(&:to_s)
  end

  def name_with_grade
    "#{user.user_key} #{battle_grade.name}"
  end

  def location
    Warabi::Location.fetch(location_key)
  end
end
