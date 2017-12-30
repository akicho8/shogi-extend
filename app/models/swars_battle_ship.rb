# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応テーブル (swars_battle_ships as SwarsBattleShip)
#
# |------------------------+---------------------+-------------+-------------+-------------------------+---------|
# | カラム名               | 意味                | タイプ      | 属性        | 参照                    | INDEX   |
# |------------------------+---------------------+-------------+-------------+-------------------------+---------|
# | id                     | ID                  | integer(8)  | NOT NULL PK |                         |         |
# | swars_battle_record_id | Swars battle record | integer(8)  | NOT NULL    | => SwarsBattleRecord#id | A! B! C |
# | swars_battle_user_id   | Swars battle user   | integer(8)  | NOT NULL    | => SwarsBattleUser#id   | B! D    |
# | swars_battle_grade_id  | Swars battle grade  | integer(8)  | NOT NULL    | => SwarsBattleGrade#id  | E       |
# | judge_key              | Judge key           | string(255) | NOT NULL    |                         | F       |
# | location_key           | Location key        | string(255) | NOT NULL    |                         | A! G    |
# | position               | 順序                | integer(4)  |             |                         | H       |
# | created_at             | 作成日時            | datetime    | NOT NULL    |                         |         |
# | updated_at             | 更新日時            | datetime    | NOT NULL    |                         |         |
# |------------------------+---------------------+-------------+-------------+-------------------------+---------|
#
#- 備考 -------------------------------------------------------------------------
# ・SwarsBattleShip モデルは SwarsBattleRecord モデルから has_many :swars_battle_ships されています。
# ・SwarsBattleShip モデルは SwarsBattleUser モデルから has_many :swars_battle_ships されています。
# ・SwarsBattleShip モデルは SwarsBattleGrade モデルから has_many :swars_battle_users されています。
#--------------------------------------------------------------------------------

class SwarsBattleShip < ApplicationRecord
  belongs_to :swars_battle_record            # 対局
  belongs_to :swars_battle_user, touch: true # 対局者
  belongs_to :swars_battle_grade             # 対局したときの段位

  acts_as_list top_of_list: 0, scope: :swars_battle_record

  scope :judge_key_eq, -> v { where(judge_key: v).take }

  # 先手/後手側の対局時の情報
  scope :black, -> { where(location_key: "black").take! }
  scope :white, -> { where(location_key: "white").take! }

  # # 勝者/敗者側の対局時の情報(引き分けの場合ない)
  # scope :win,  -> { judge_key_eq(:win)  }
  # scope :lose, -> { judge_key_eq(:lose) }

  # swars_battle_user に対する自分/相手
  scope :myself, -> swars_battle_user { where(swars_battle_user_id: swars_battle_user.id).take!     }
  scope :rival,  -> swars_battle_user { where.not(swars_battle_user_id: swars_battle_user.id).take! }

  acts_as_ordered_taggable_on :defense_tags
  acts_as_ordered_taggable_on :attack_tags

  before_validation do
    # 無かったときだけ入れる(絶対あるんだけど)
    if swars_battle_user
      self.swars_battle_grade ||= swars_battle_user.swars_battle_grade
    end
  end

  with_options presence: true do
    validates :judge_key
    validates :location_key
  end

  with_options allow_blank: true do
    validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
    validates :swars_battle_user_id, uniqueness: {scope: :swars_battle_record_id}
    validates :location_key, uniqueness: {scope: :swars_battle_record_id}
    validates :location_key, inclusion: Bushido::Location.keys.collect(&:to_s)
  end

  def name_with_grade
    "#{swars_battle_user.user_key} #{swars_battle_grade.name}"
  end

  def location
    Bushido::Location.fetch(location_key)
  end
end
