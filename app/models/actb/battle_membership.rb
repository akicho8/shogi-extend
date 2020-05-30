# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Membership (actb_battle_memberships as Actb::Membership)
#
# |----------------+----------------+-------------+-------------+-----------------------+-------|
# | name           | desc           | type        | opts        | refs                  | index |
# |----------------+----------------+-------------+-------------+-----------------------+-------|
# | id             | ID             | integer(8)  | NOT NULL PK |                       |       |
# | battle_id        | Battle           | integer(8)  |             |                       | A! B  |
# | user_id        | User           | integer(8)  |             | => Colosseum::User#id | A! C  |
# | judge_key      | Judge key      | string(255) |             |                       | D     |
# | rensho_count   | Rensho count   | integer(4)  | NOT NULL    |                       | E     |
# | renpai_count   | Renpai count   | integer(4)  | NOT NULL    |                       | F     |
# | question_index | Question index | integer(4)  |             |                       |       |
# | position       | 順序           | integer(4)  |             |                       | G     |
# | created_at     | 作成日時       | datetime    | NOT NULL    |                       |       |
# | updated_at     | 更新日時       | datetime    | NOT NULL    |                       |       |
# |----------------+----------------+-------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_profile
#--------------------------------------------------------------------------------

module Actb
  class BattleMembership < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :battle
    belongs_to :judge

    acts_as_list top_of_list: 0, scope: :battle

    before_validation do
      self.judge ||= Judge.fetch(:pending)

      self.rensho_count ||= 0
      self.renpai_count ||= 0

      if changes_to_save[:judge] && judge && judge.win_or_lose?
        w = 0
        l = 0
        if record = maeno_record
          w = record.rensho_count
          l = record.renpai_count
        end
        if judge.key == "win"
          w += 1
          l = 0
        end
        if judge.key == "lose"
          w = 0
          l += 1
        end
        self.rensho_count = w
        self.renpai_count = l

        # 一問も答えてないとき nil になるため
        self.question_index ||= 0
      end
    end

    with_options presence: true do
      validates :user_id
      validates :battle_id
      validates :judge_id
    end

    with_options allow_blank: true do
      validates :user_id, uniqueness: { scope: :battle_id }
    end

    after_save do
      if saved_changes[:judge] && judge && judge.win_or_lose?
        record = user.actb_newest_profile
        # record.rensho_count = rensho_count # membershipの方に持つ必要ある？？？
        # record.renpai_count = renpai_count
        record.judge = judge
        record.save!
      end
    end

    def judge_info
      JudgeInfo.fetch_if(judge_key)
    end

    def maeno_record
      s = user.actb_battle_memberships
      if created_at
        s = s.where(self.class.arel_table[:created_at].lt(created_at))
      end
      s = s.joins(:judge).merge(Judge.win_or_lose)
      s = s.order(:created_at)
      s.last
    end
  end
end
