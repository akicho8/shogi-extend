# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Membership (general_memberships as General::Membership)
#
# |--------------+--------------+-------------+-------------+------+-------|
# | name         | desc         | type        | opts        | refs | index |
# |--------------+--------------+-------------+-------------+------+-------|
# | id           | ID           | integer(8)  | NOT NULL PK |      |       |
# | battle_id    | Battle       | integer(8)  | NOT NULL    |      | A! B  |
# | judge_key    | Judge key    | string(255) | NOT NULL    |      | C     |
# | location_key | Location key | string(255) | NOT NULL    |      | A! D  |
# | position     | 順序         | integer(4)  |             |      | E     |
# | created_at   | 作成日時     | datetime    | NOT NULL    |      |       |
# | updated_at   | 更新日時     | datetime    | NOT NULL    |      |       |
# |--------------+--------------+-------------+-------------+------+-------|

module General
  class Membership < ApplicationRecord
    belongs_to :battle            # 対局

    acts_as_list top_of_list: 0, scope: :battle

    scope :judge_key_eq, -> v { where(judge_key: v).take }

    # 先手/後手側の対局時の情報
    scope :black, -> { where(location_key: "black").take! }
    scope :white, -> { where(location_key: "white").take! }

    acts_as_ordered_taggable_on :defense_tags
    acts_as_ordered_taggable_on :attack_tags
    acts_as_ordered_taggable_on :technique_tags
    acts_as_ordered_taggable_on :note_tags

    with_options presence: true do
      validates :judge_key
      validates :location_key
    end

    with_options allow_blank: true do
      validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
      validates :location_key, uniqueness: {scope: :battle_id}
      validates :location_key, inclusion: Bioshogi::Location.keys.collect(&:to_s)
    end

    def location
      Bioshogi::Location.fetch(location_key)
    end
  end
end
