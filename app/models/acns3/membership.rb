# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Membership (acns3_memberships as Acns3::Membership)
#
# |--------------+--------------+-------------+-------------+-----------------------+-------|
# | name         | desc         | type        | opts        | refs                  | index |
# |--------------+--------------+-------------+-------------+-----------------------+-------|
# | id           | ID           | integer(8)  | NOT NULL PK |                       |       |
# | room_id      | Room         | integer(8)  |             |                       | A! B  |
# | user_id      | User         | integer(8)  |             | => Colosseum::User#id | A! C  |
# | judge_key    | Judge key    | string(255) |             |                       | D     |
# | rensho_count | Rensho count | integer(4)  | NOT NULL    |                       | E     |
# | renpai_count | Renpai count | integer(4)  | NOT NULL    |                       | F     |
# | quest_index  | Quest index  | integer(4)  |             |                       |       |
# | position     | 順序         | integer(4)  |             |                       | G     |
# | created_at   | 作成日時     | datetime    | NOT NULL    |                       |       |
# | updated_at   | 更新日時     | datetime    | NOT NULL    |                       |       |
# |--------------+--------------+-------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_many :acns2_memberships
#--------------------------------------------------------------------------------

module Acns3
  class Membership < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :room

    acts_as_list top_of_list: 0, scope: :room

    before_validation do
      self.rensho_count ||= 0
      self.renpai_count ||= 0

      if changes_to_save[:judge_key] && judge_key
        w = 0
        l = 0
        if record = maeno_record
          w = record.rensho_count
          l = record.renpai_count
        end
        if judge_key == "win"
          w += 1
          l = 0
        end
        if judge_key == "lose"
          w = 0
          l += 1
        end
        self.rensho_count = w
        self.renpai_count = l

        # 一問も答えてないとき nil になるため
        self.quest_index ||= 0
      end
    end

    with_options allow_blank: true do
      validates :judge_key, inclusion: JudgeInfo.keys.collect(&:to_s)
      validates :judge_key, uniqueness: { scope: :room_id, case_sensitive: true }
    end

    after_save do
      user.acns3_profile.update!(rensho_count: rensho_count, renpai_count: renpai_count)
    end

    def maeno_record
      s = user.acns3_memberships
      if created_at
        s = s.where(self.class.arel_table[:created_at].lt(created_at))
      end
      s = s.where.not(judge_key: nil)
      s = s.order(:created_at)
      s.last
    end
  end
end
