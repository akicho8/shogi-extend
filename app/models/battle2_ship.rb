# -*- coding: utf-8 -*-
# == Schema Information ==
#
# 対局と対局者の対応テーブル (battle2_ships as Battle2Ship)
#
# |------------------+---------------+-------------+-------------+--------------------+---------|
# | カラム名         | 意味          | タイプ      | 属性        | 参照               | INDEX   |
# |------------------+---------------+-------------+-------------+--------------------+---------|
# | id               | ID            | integer(8)  | NOT NULL PK |                    |         |
# | battle2_record_id | Battle2 record | integer(8)  | NOT NULL    | => Battle2Record#id | A! B! C |
# | battle2_user_id   | Battle2 user   | integer(8)  | NOT NULL    | => Battle2User#id   | B! D    |
# | battle2_grade_id  | Battle2 grade  | integer(8)  | NOT NULL    | => Battle2Grade#id  | E       |
# | judge_key        | Judge key     | string(255) | NOT NULL    |                    | F       |
# | location_key     | Location key  | string(255) | NOT NULL    |                    | A! G    |
# | position         | 順序          | integer(4)  |             |                    | H       |
# | created_at       | 作成日時      | datetime    | NOT NULL    |                    |         |
# | updated_at       | 更新日時      | datetime    | NOT NULL    |                    |         |
# |------------------+---------------+-------------+-------------+--------------------+---------|
#
#- 備考 -------------------------------------------------------------------------
# ・Battle2Ship モデルは Battle2Record モデルから has_many :battle2_ships されています。
# ・Battle2Ship モデルは Battle2User モデルから has_many :battle2_ships されています。
# ・Battle2Ship モデルは Battle2Grade モデルから has_many :battle2_users されています。
#--------------------------------------------------------------------------------

class Battle2Ship < ApplicationRecord
  belongs_to :battle2_record            # 対局
  belongs_to :battle2_user, touch: true # 対局者
  belongs_to :battle2_grade             # 対局したときの段位

  acts_as_list top_of_list: 0, scope: :battle2_record

  scope :judge_key_eq, -> v { where(judge_key: v).take }

  # 先手/後手側の対局時の情報
  scope :black, -> { where(location_key: "black").take! }
  scope :white, -> { where(location_key: "white").take! }

  # # 勝者/敗者側の対局時の情報(引き分けの場合ない)
  # scope :win,  -> { judge_key_eq(:win)  }
  # scope :lose, -> { judge_key_eq(:lose) }

  # battle2_user に対する自分/相手
  scope :myself, -> battle2_user { where(battle2_user_id: battle2_user.id).take!     }
  scope :rival,  -> battle2_user { where.not(battle2_user_id: battle2_user.id).take! }

  acts_as_ordered_taggable_on :defense_tags
  acts_as_ordered_taggable_on :attack_tags

  # before_validation do
  #   # 無かったときだけ入れる(絶対あるんだけど)
  #   # if battle2_user
  #   #   self.battle2_grade ||= battle2_user.battle2_grade
  #   # end
  # end

  with_options presence: true do
    validates :judge_key
    validates :location_key
  end

  with_options allow_blank: true do
    validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
    validates :battle2_user_id, uniqueness: {scope: :battle2_record_id}
    validates :location_key, uniqueness: {scope: :battle2_record_id}
    validates :location_key, inclusion: Bushido::Location.keys.collect(&:to_s)
  end

  def name_with_grade
    "#{battle2_user.uid} #{battle2_grade.name}"
  end

  def location
    Bushido::Location.fetch(location_key)
  end
end
