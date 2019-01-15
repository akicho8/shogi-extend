# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Membership (swars_memberships as Swars::Membership)
#
# |--------------+--------------+-------------+-------------+------+---------|
# | name         | desc         | type        | opts        | refs | index   |
# |--------------+--------------+-------------+-------------+------+---------|
# | id           | ID           | integer(8)  | NOT NULL PK |      |         |
# | battle_id    | Battle       | integer(8)  | NOT NULL    |      | A! B! C |
# | user_id      | User         | integer(8)  | NOT NULL    |      | B! D    |
# | grade_id     | Grade        | integer(8)  | NOT NULL    |      | E       |
# | judge_key    | Judge key    | string(255) | NOT NULL    |      | F       |
# | location_key | Location key | string(255) | NOT NULL    |      | A! G    |
# | position     | 順序         | integer(4)  |             |      | H       |
# | created_at   | 作成日時     | datetime    | NOT NULL    |      |         |
# | updated_at   | 更新日時     | datetime    | NOT NULL    |      |         |
# |--------------+--------------+-------------+-------------+------+---------|

module Swars
  class Membership < ApplicationRecord
    belongs_to :battle            # 対局
    belongs_to :user, touch: true # 対局者
    belongs_to :grade             # 対局したときの段位

    acts_as_list top_of_list: 0, scope: :battle

    default_scope { order(:position) }

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
        self.grade ||= user.grade
      end
    end

    with_options presence: true do
      validates :judge_key
      validates :location_key
    end

    with_options allow_blank: true do
      validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
      validates :user_id, uniqueness: {scope: :battle_id}
      validates :location_key, uniqueness: {scope: :battle_id}
      validates :location_key, inclusion: Warabi::Location.keys.collect(&:to_s)
    end

    def name_with_grade
      "#{user.user_key} #{grade.name}"
    end

    def location
      Warabi::Location.fetch(location_key)
    end
  end
end
