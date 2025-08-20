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

    after_save :user_record_update

    ################################################################################

    def user_record_update
      user_age_set
      user_result_set
      user_term_set
      user_win_lose_set
      user.save!
    end

    def user_age_set
      user.age_min = user.memberships.minimum(:age)
      user.age_max = user.memberships.maximum(:age)
    end

    def user_result_set
      if saved_change_to_attribute?(:result_id)
        if result.key == "runner_up"
          user.runner_up_count += 1
        end
        if result.key == "promotion" || user.runner_up_count >= User::PROMOTABLE_RUNNER_UP_COUNT
          user.promotion_membership = self
          user.promotion_season_number = league_season.season_number
          user.promotion_win = win
        end
      end
    end

    # 在籍の開始と終了のレコードを一発で引けるようにしておく
    def user_term_set
      memberships = user.memberships.minmax_by { |e| e.league_season.season_number }
      user.memberships_first, user.memberships_last = memberships
      user.season_number_min, user.season_number_max = memberships.collect { |e| e&.league_season.season_number }
    end

    # 勝ち負けに関する情報を反映する
    def user_win_lose_set
      user.win_max    = user.memberships.maximum(:win)
      user.total_win  = user.memberships.sum(:win)
      user.total_lose = user.memberships.sum(:lose)
    end

    ################################################################################
  end
end
