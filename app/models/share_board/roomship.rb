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

    def score_post_to_redis
      redis.call("ZADD", room.redis_key, score, user.id)
    end

    def rank_update
      update!(rank: room.rank_by_score(score))
    end

    def redis
      @redis ||= RedisClient.new(db: AppConfig[:redis_db_for_share_board_room])
    end
  end
end
