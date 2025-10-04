# -*- coding: utf-8 -*-

# == Schema Information ==
#
# Roomship (share_board_roomships as ShareBoard::Roomship)
#
# |---------------+---------------+------------+-------------+------------+-------|
# | name          | desc          | type       | opts        | refs       | index |
# |---------------+---------------+------------+-------------+------------+-------|
# | id            | ID            | integer(8) | NOT NULL PK |            |       |
# | room_id       | Room          | integer(8) | NOT NULL    |            | A     |
# | user_id       | User          | integer(8) | NOT NULL    | => User#id | B     |
# | win_count     | Win count     | integer(4) | NOT NULL    |            | C     |
# | lose_count    | Lose count    | integer(4) | NOT NULL    |            | D     |
# | battles_count | Battles count | integer(4) | NOT NULL    |            |       |
# | win_rate      | Win rate      | float(24)  | NOT NULL    |            | E     |
# | score         | Score         | integer(4) | NOT NULL    |            | F     |
# | rank          | Rank          | integer(4) | NOT NULL    |            | G     |
# | created_at    | 作成日時      | datetime   | NOT NULL    |            |       |
# | updated_at    | 更新日時      | datetime   | NOT NULL    |            |       |
# |---------------+---------------+------------+-------------+------------+-------|
#
# - Remarks ----------------------------------------------------------------------
# User.has_one :profile
# --------------------------------------------------------------------------------

module ShareBoard
  class Roomship < ApplicationRecord
    belongs_to :user # 対局者
    belongs_to :room # 所属する部屋

    default_scope { order(:rank) }

    before_validation do
      self.win_count ||= 0
      self.lose_count ||= 0
      self.battles_count = win_count + lose_count
      if battles_count.zero?
        self.win_rate = 0
      else
        self.win_rate = win_count.fdiv(battles_count)
      end
      self.score = win_count
      self.rank ||= -1
    end

    with_options presence: true do
      validates :win_count
      validates :lose_count
      validates :win_rate
      validates :score
      validates :rank
    end

    after_save do
      if saved_change_to_attribute?(:score)
        score_post_to_redis
      end
    end

    ################################################################################

    def score_post_to_redis
      redis.call("ZADD", room.redis_key, score, user.id)
    end

    def rank_update
      update!(rank: room.rank_by_score(score))
    end

    def redis
      @redis ||= RedisClient.new(db: AppConfig[:redis_db_for_share_board_room])
    end

    ################################################################################

    def match_record
      {
        win_count: win_count,
        lose_count: lose_count,
      }
    end

    def users_match_record
      { user.name => match_record }
    end

    ################################################################################
  end
end
