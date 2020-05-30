# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle membership (actb_battle_memberships as Actb::BattleMembership)
#
# |----------------+----------------+------------+-------------+-----------------------+-------|
# | name           | desc           | type       | opts        | refs                  | index |
# |----------------+----------------+------------+-------------+-----------------------+-------|
# | id             | ID             | integer(8) | NOT NULL PK |                       |       |
# | battle_id      | Battle         | integer(8) | NOT NULL    |                       | A! B  |
# | user_id        | User           | integer(8) | NOT NULL    | => Colosseum::User#id | A! C  |
# | judge_id       | Judge          | integer(8) | NOT NULL    |                       | D     |
# | question_index | Question index | integer(4) |             |                       |       |
# | position       | 順序           | integer(4) | NOT NULL    |                       | E     |
# | created_at     | 作成日時       | datetime   | NOT NULL    |                       |       |
# | updated_at     | 更新日時       | datetime   | NOT NULL    |                       |       |
# |----------------+----------------+------------+-------------+-----------------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# Colosseum::User.has_one :actb_xrecord
#--------------------------------------------------------------------------------

module Actb
  class BattleMembership < ApplicationRecord
    belongs_to :user, class_name: "Colosseum::User" # , foreign_key: "colosseum_user_id"
    belongs_to :battle, inverse_of: :memberships
    belongs_to :judge

    acts_as_list top_of_list: 0, scope: :battle

    before_validation do
      self.judge ||= Judge.fetch(:pending)

      # self.rensho_count ||= 0
      # self.renpai_count ||= 0

      # if changes_to_save[:judge] && judge && judge.win_or_lose?
      #   w = 0
      #   l = 0
      #   if record = maeno_record
      #     w = record.rensho_count
      #     l = record.renpai_count
      #   end
      #   if judge.key == "win"
      #     w += 1
      #     l = 0
      #   end
      #   if judge.key == "lose"
      #     w = 0
      #     l += 1
      #   end
      #   self.rensho_count = w
      #   self.renpai_count = l
      # end

      # 一問も答えてないとき nil になるため
      self.question_index ||= 0
    end

    with_options allow_blank: true do
      validates :user_id, uniqueness: { scope: :battle_id }
    end

    after_save do
      if saved_changes[:judge] && judge && judge.win_or_lose?
        xrecord = user.actb_newest_xrecord
        # xrecord.rensho_count = rensho_count # membershipの方に持つ必要ある？？？
        # xrecord.renpai_count = renpai_count
        xrecord.judge = judge
        xrecord.save!
      end
    end

    def judge_info
      judge.static_info
    end

    # def maeno_record
    #   s = user.actb_battle_memberships
    #   if created_at
    #     s = s.where(self.class.arel_table[:created_at].lt(created_at))
    #   end
    #   s = s.joins(:judge).merge(Judge.win_or_lose)
    #   s = s.order(:created_at)
    #   s.last
    # end
  end
end
