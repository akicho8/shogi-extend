# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Battle membership (emox_battle_memberships as Emox::BattleMembership)
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
# User.has_one :profile
#--------------------------------------------------------------------------------

module Emox
  class BattleMembership < ApplicationRecord
    belongs_to :user, class_name: "::User"
    belongs_to :battle, inverse_of: :memberships
    belongs_to :judge

    acts_as_list top_of_list: 0, scope: :battle

    before_validation do
      if Rails.env.test?
        self.user ||= User.create!
      end

      self.judge ||= Judge.fetch(:pending)
    end

    with_options allow_blank: true do
      validates :user_id, uniqueness: { scope: :battle_id }
    end

    def judge_info
      judge.pure_info
    end

    # rails r "p Emox::Battle.first.memberships.first.location_key"
    def location_key
      Bioshogi::Location.fetch(position).key
    end
  end
end
