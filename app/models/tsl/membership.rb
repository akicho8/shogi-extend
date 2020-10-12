# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Membership (tsl_memberships as Tsl::Membership)
#
# |--------------------------+--------------------------+-------------+-------------+------------+-------|
# | name                     | desc                     | type        | opts        | refs       | index |
# |--------------------------+--------------------------+-------------+-------------+------------+-------|
# | id                       | ID                       | integer(8)  | NOT NULL PK |            |       |
# | league_id                | League                   | integer(8)  | NOT NULL    |            | A! B  |
# | user_id                  | User                     | integer(8)  | NOT NULL    | => User#id | A! C  |
# | result_key               | Result key               | string(255) | NOT NULL    |            | D     |
# | start_pos                | Start pos                | integer(4)  | NOT NULL    |            | E     |
# | age                      | Age                      | integer(4)  |             |            |       |
# | win                      | Win                      | integer(4)  |             |            | F     |
# | lose                     | Lose                     | integer(4)  |             |            | G     |
# | ox                       | Ox                       | string(255) | NOT NULL    |            |       |
# | previous_runner_up_count | Previous runner up count | integer(4)  | NOT NULL    |            | H     |
# | seat_count               | Seat count               | integer(4)  | NOT NULL    |            |       |
# | created_at               | 作成日時                 | datetime    | NOT NULL    |            |       |
# | updated_at               | 更新日時                 | datetime    | NOT NULL    |            |       |
# |--------------------------+--------------------------+-------------+-------------+------------+-------|
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
      self.previous_runner_up_count = user.runner_up_count
      self.seat_count = user.seat_count(league.generation) + 1 # 在籍数(自分を含むため+1)
    end

    with_options presence: true do
      validates :start_pos
      validates :win
      validates :lose
      validates :seat_count
    end

    after_save do
      if saved_change_to_attribute?(:age) && age
        if !user.first_age || age < user.first_age
          user.first_age = age
        end
        if !user.last_age || age > user.last_age
          user.last_age = age
        end
      end

      if saved_change_to_attribute?(:result_key) && result_key
        if level_up_p
          user.level_up_generation ||= league.generation
        end
        if runner_up_p
          user.runner_up_count += 1
        end
      end

      user.save!
    end

    def name_with_age
      s = user.name
      if age
        s += "(#{age})"
      end
      # if user.level_up_generation
      #   s += " ★"
      # end
      s
    end

    def ox_human
      # ox.tr("ox", "🍓💀")
      # ox.tr("ox", "🍎💀")
      ox.tr("ox", "○●")
    end

    def result_mark
      if result_key != "none"
        result_key[0]
      end
    end

    # プロになったか？
    def level_up_p
      result_key.include?("昇")
    end

    # 次点あり？
    def runner_up_p
      result_key.include?("次")
    end

    # 降段
    def level_down_p
      result_key.include?("降")
    end
  end
end
