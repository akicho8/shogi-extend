# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle membership (actb_battle_memberships as Actb::BattleMembership)
#
# |------------+----------+------------+-------------+--------------+-------|
# | name       | desc     | type       | opts        | refs         | index |
# |------------+----------+------------+-------------+--------------+-------|
# | id         | ID       | integer(8) | NOT NULL PK |              |       |
# | battle_id  | Battle   | integer(8) | NOT NULL    |              | A! B  |
# | user_id    | User     | integer(8) | NOT NULL    | => ::User#id | A! C  |
# | judge_id   | Judge    | integer(8) | NOT NULL    |              | D     |
# | position   | 順序     | integer(4) | NOT NULL    |              | E     |
# | created_at | 作成日時 | datetime   | NOT NULL    |              |       |
# | updated_at | 更新日時 | datetime   | NOT NULL    |              |       |
# |------------+----------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

module Actb
  class BattleMembership < ApplicationRecord
    belongs_to :user, class_name: "::User"
    belongs_to :battle, inverse_of: :memberships
    belongs_to :judge
    has_many :histories, foreign_key: :membership_id, dependent: :destroy

    acts_as_list top_of_list: 0, scope: :battle

    before_validation do
      if Rails.env.test?
        self.user ||= User.create!
      end

      self.judge ||= Judge.fetch(:pending)

      # self.straight_win_count ||= 0
      # self.straight_lose_count ||= 0

      # if changes_to_save[:judge] && judge && judge.win_or_lose?
      #   w = 0
      #   l = 0
      #   if record = maeno_record
      #     w = record.straight_win_count
      #     l = record.straight_lose_count
      #   end
      #   if judge.key == "win"
      #     w += 1
      #     l = 0
      #   end
      #   if judge.key == "lose"
      #     w = 0
      #     l += 1
      #   end
      #   self.straight_win_count = w
      #   self.straight_lose_count = l
      # end
    end

    with_options allow_blank: true do
      validates :user_id, uniqueness: { scope: :battle_id }
    end

    # after_save do
    #   if saved_changes[:judge] && judge && judge.win_or_lose?
    #     season_xrecord = user.actb_latest_xrecord
    #     season_xrecord.judge = judge
    #     season_xrecord.save!
    #   end
    # end

    def judge_info
      judge.pure_info
    end

    # def judge_key=(key)
    #   self.judge = Judge.fetch(key)
    # end
    #
    # def judge_key
    #   self.judge.key
    # end

    # def maeno_record
    #   s = user.actb_battle_memberships
    #   if created_at
    #     s = s.where(self.class.arel_table[:created_at].lt(created_at))
    #   end
    #   s = s.joins(:judge).merge(Judge.win_or_lose)
    #   s = s.order(:created_at)
    #   s.last
    # end

    def room_speak(message_body, options = {})
      user.room_speak(battle.room, message_body, options)
    end
  end
end
