module Colosseum
  class Aggregator
    cattr_accessor(:accuracy)  { 1000 }

    attr_accessor :key

    def initialize(key)
      @key = key
    end

    def aggregate
      current_clean
      win_ratio_scope.each do |row|
        redis.zadd(inside_key, row["win_ratio"], row["user_id"])
      end
    end

    def all
      @all ||= -> {
        aggregate
        redis.zrevrange(inside_key, 0, -1, with_scores: true).collect do |user_id, score|
          rank = redis.zcount(inside_key, score + 1, "+inf") + 1
          {rank: rank, user_id: user_id, win_ratio: score.fdiv(accuracy)}
        end
      }.call
    end

    private

    def inside_key
      "ranking_#{key}"
    end

    def current_clean
      redis.del(inside_key)
    end

    def redis
      @redis ||= Redis.new(host: "localhost", port: 6379, db: 1)
    end

    def win_ratio_scope
      @win_ratio_scope ||= ActiveRecord::Base.connection.select_all(<<~SQL)
      select user_id, floor(win / (win + lose) * #{accuracy}) as win_ratio
        from (#{chronicle_scope.to_sql}) as chronicles
          order by win_ratio desc
          SQL
    end

    def chronicle_scope
      Chronicle.select("user_id, sum(case when judge_key = 'win' then 1 else 0 end) as win, sum(case when judge_key='lose' then 1 else 0 end) as lose").group("user_id")
    end
  end

  if $0 == __FILE__
    User.destroy_all

    user = User.create!

    user = User.create!
    user.judge_add(:win)
    user.judge_add(:lose)

    user = User.create!
    user.judge_add(:win)
    user.judge_add(:win)

    aggregator = Aggregator.new
    aggregator.aggregate
    tp aggregator.all
  end
end
