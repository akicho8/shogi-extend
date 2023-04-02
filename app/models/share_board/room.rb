module ShareBoard
  class Room < ApplicationRecord
    class << self
      def fetch(key)
        find_by!(key: key)
      end
    end

    # alias_attribute :code, :key

    has_many :battles, -> { order(created_at: :desc) }, dependent: :destroy, inverse_of: :room
    has_many :memberships, through: :battles
    has_many :users, through: :memberships

    has_many :roomships, dependent: :destroy, inverse_of: :room

    before_validation do
      self.key ||= "dev_room"
    end

    with_options presence: true do
      validates :key
    end

    def score_by_user(user)
      memberships.where(user: user, judge: Judge.fetch(:win)).count
    end

    def ox_count_by_user(user, judge)
      memberships.where(user: user, judge: Judge.fetch(judge)).count
    end

    def rank_by_score(score)
      redis.call("ZCOUNT", redis_key, score + 1, "+inf") + 1
    end

    def redis_clear
      redis.call("DEL", redis_key)
    end

    def redis_key
      id
    end

    def redis_rebuild
      redis_clear
      roomships.each(&:score_post_to_redis)
      roomships.each(&:rank_update)
    end

    def redis
      @redis ||= RedisClient.new(db: AppConfig[:redis_db_for_share_board_room])
    end
  end
end
