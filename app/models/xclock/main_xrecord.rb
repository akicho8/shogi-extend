# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Main xrecord (xclock_main_xrecords as Xclock::MainXrecord)
#
# |---------------------+---------------------+------------+-------------+--------------+-------|
# | name                | desc                | type       | opts        | refs         | index |
# |---------------------+---------------------+------------+-------------+--------------+-------|
# | id                  | ID                  | integer(8) | NOT NULL PK |              |       |
# | user_id             | User                | integer(8) | NOT NULL    | => ::User#id | A!    |
# | judge_id            | Judge               | integer(8) | NOT NULL    |              | B     |
# | final_id            | Final               | integer(8) | NOT NULL    |              | C     |
# | battle_count        | Battle count        | integer(4) | NOT NULL    |              | D     |
# | win_count           | Win count           | integer(4) | NOT NULL    |              | E     |
# | lose_count          | Lose count          | integer(4) | NOT NULL    |              | F     |
# | win_rate            | Win rate            | float(24)  | NOT NULL    |              | G     |
# | rating              | Rating              | float(24)  | NOT NULL    |              | H     |
# | rating_diff         | Rating diff         | float(24)  | NOT NULL    |              | I     |
# | rating_max          | Rating max          | float(24)  | NOT NULL    |              | J     |
# | straight_win_count  | Straight win count  | integer(4) | NOT NULL    |              | K     |
# | straight_lose_count | Straight lose count | integer(4) | NOT NULL    |              | L     |
# | straight_win_max    | Straight win max    | integer(4) | NOT NULL    |              | M     |
# | straight_lose_max   | Straight lose max   | integer(4) | NOT NULL    |              | N     |
# | skill_id            | Skill               | integer(8) | NOT NULL    |              | O     |
# | skill_point         | Skill point         | float(24)  | NOT NULL    |              |       |
# | skill_last_diff     | Skill last diff     | float(24)  | NOT NULL    |              |       |
# | created_at          | 作成日時            | datetime   | NOT NULL    |              |       |
# | updated_at          | 更新日時            | datetime   | NOT NULL    |              |       |
# | disconnect_count    | Disconnect count    | integer(4) | NOT NULL    |              | P     |
# | disconnected_at     | Disconnected at     | datetime   |             |              |       |
# |---------------------+---------------------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_one :profile
#--------------------------------------------------------------------------------

module Xclock
  class MainXrecord < ApplicationRecord
    include XrecordShareMod

    with_options presence: true do
      validates :user_id
    end

    with_options allow_blank: true do
      validates :user_id, uniqueness: true
    end

    def rating_default
      EloRating.rating_default
    end
  end
end
