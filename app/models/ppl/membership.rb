# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Membership (ppl_memberships as Ppl::Membership)
#
# |--------------------------+--------------------------+-------------+-------------+------------+-------|
# | name                     | desc                     | type        | opts        | refs       | index |
# |--------------------------+--------------------------+-------------+-------------+------------+-------|
# | id                       | ID                       | integer(8)  | NOT NULL PK |            |       |
# | league_season_id                | LeagueSeason                   | integer(8)  | NOT NULL    |            | A! B  |
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
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# --------------------------------------------------------------------------------

module Ppl
  class Membership < ApplicationRecord
    belongs_to :league_season                                                                  # 対局
    belongs_to :user, counter_cache: true                                               # 参加者
    custom_belongs_to :result, ar_model: Result, st_model: ResultInfo, default: :retain # 結果

    before_validation do
      self.start_pos ||= 0
      self.win ||= 0
      self.lose ||= 0
      self.ox ||= ""
    end

    with_options presence: true do
      validates :start_pos
      validates :win
      validates :lose
    end

    after_save do
      if saved_change_to_attribute?(:age) && age
        user.age_min = [age, (user.age_min || Float::INFINITY)].min
        user.age_max = [age, (user.age_max || 0)].max
      end

      if saved_change_to_attribute?(:result_id)
        case result.key
        when "promotion"        # 昇段
          user.promotion_membership = self
          user.promotion_season_number = league_season.season_number
          user.promotion_win = win
        when "runner_up"        # 次点
          user.runner_up_count += 1
        end
      end

      # 在籍の開始と終了のレコードを一発で引けるようにしておく
      memberships = user.memberships.minmax_by { |e| e.league_season.season_number }
      user.memberships_first, user.memberships_last = memberships
      user.season_number_min, user.season_number_max = memberships.collect { |e| e&.league_season.season_number }

      # 最大勝数を保持しておく
      if saved_change_to_attribute?(:win) && win
        user.win_max = [(user.win_max || 0), win].max
      end

      user.save!
    end
  end
end
