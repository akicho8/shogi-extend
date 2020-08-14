# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Season xrecord (actb_season_xrecords as Actb::SeasonXrecord)
#
# |---------------------+---------------------+------------+-------------+--------------+-------|
# | name                | desc                | type       | opts        | refs         | index |
# |---------------------+---------------------+------------+-------------+--------------+-------|
# | id                  | ID                  | integer(8) | NOT NULL PK |              |       |
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
# | user_id             | User                | integer(8) | NOT NULL    | => ::User#id | A! Q  |
# | season_id           | Season              | integer(8) | NOT NULL    |              | A! R  |
# | create_count        | Create count        | integer(4) | NOT NULL    |              | S     |
# | generation          | Generation          | integer(4) | NOT NULL    |              | T     |
# |---------------------+---------------------+------------+-------------+--------------+-------|
#
#- Remarks ----------------------------------------------------------------------
# User.has_many :actb_room_messages
#--------------------------------------------------------------------------------

module Actb
  class SeasonXrecord < ApplicationRecord
    include XrecordShareMod

    belongs_to :season

    before_validation do
      self.season ||= Season.newest
      self.generation ||= season.generation
      self.create_count ||= user.actb_season_xrecords.count.next
    end

    with_options allow_blank: true do
      validates :user_id, uniqueness: { scope: :season_id }
    end

    # 連勝通知
    # rails r "User.first.actb_latest_xrecord.judge_set(Judge.fetch(:win))"
    STRAIGHT_WIN_COUNT_SEGMENTS = 5
    after_save_commit do
      if saved_change_to_attribute?(:straight_win_count)
        if straight_win_count >= 1
          if straight_win_count.modulo(STRAIGHT_WIN_COUNT_SEGMENTS).zero?
            user.straight_win_count_notify
          end
        end
      end
    end

    def rating_default
      # 毎回 1500 から開始
      # レーティングは表示させないのでこれでよい
      EloRating.rating_default

      # 永続的レーティングを引き継ぐ場合
      # user.rating
    end
  end
end
