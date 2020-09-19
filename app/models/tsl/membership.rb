# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Membership (tsl_memberships as Tsl::Membership)
#
# |------------+------------+-------------+-------------+------------+-------|
# | name       | desc       | type        | opts        | refs       | index |
# |------------+------------+-------------+-------------+------------+-------|
# | id         | ID         | integer(8)  | NOT NULL PK |            |       |
# | league_id  | League     | integer(8)  | NOT NULL    |            | A! B  |
# | user_id    | User       | integer(8)  | NOT NULL    | => User#id | A! C  |
# | result_key | Result key | string(255) | NOT NULL    |            | D     |
# | start_pos  | Start pos  | integer(4)  | NOT NULL    |            | E     |
# | age        | Age        | integer(4)  |             |            |       |
# | win        | Win        | integer(4)  |             |            | F     |
# | lose       | Lose       | integer(4)  |             |            | G     |
# | ox         | Ox         | string(255) | NOT NULL    |            |       |
# | created_at | 作成日時   | datetime    | NOT NULL    |            |       |
# | updated_at | 更新日時   | datetime    | NOT NULL    |            |       |
# |------------+------------+-------------+-------------+------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Tsl
  class Membership < ApplicationRecord
    belongs_to :league                      # 対局
    belongs_to :user, counter_cache: true   # 参加者

    before_validation on: :create do
      self.ox ||= ""
    end

    with_options presence: true do
      validates :start_pos
      validates :win
      validates :lose
    end

    after_create do
      if age
        if !user.first_age || age < user.first_age
          user.update!(first_age: age)
        end
        if !user.last_age || age > user.last_age
          user.update!(last_age: age)
        end
      end

      if break_through_p
        user.update!(break_through_generation: league.generation)
      end
    end

    def name_with_age
      s = user.name
      if age
        s += "(#{age})"
      end
      if user.break_through_generation
        s += " ★"
      end
      s
    end

    def ox_human
      ox.tr("ox", "○●")
    end

    def result_mark
      if result_key != "none"
        result_key[0]
      end
    end

    # 在籍数
    def seat_count
      user.seat_count(league.generation)
    end

    # プロになったか？
    def break_through_p
      result_key.include?("昇")
    end
  end
end
