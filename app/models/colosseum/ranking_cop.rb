module Colosseum
  class RankingCop
    GETA = 1000

    def aggregate_run
      current_clean
      win_ratio_scope.each do |row|
        redis.zadd(ranking_key, row["win_ratio"], row["user_id"])
      end
    end

    def all_rows
      @all_rows ||= redis.zrevrange(ranking_key, 0, -1, with_scores: true).collect do |user_id, score|
        rank = redis.zcount(ranking_key, score + 1, "+inf") + 1
        {rank: rank, user_id: user_id, win_ratio: score.fdiv(GETA)}
      end
    end

    private

    def ranking_key
      "lifetime_ranking"
    end

    def current_clean
      redis.del(ranking_key)
    end

    def redis
      @redis ||= Redis.new(host: "localhost", port: 6379, db: 1)
    end

    def win_ratio_scope
      @win_ratio_scope ||= ActiveRecord::Base.connection.select_all("select user_id, floor(win / (win + lose) * #{GETA}) as win_ratio from (#{chronicle_scope.to_sql}) as chronicles order by win_ratio desc")
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

    ranking_cop = RankingCop.new
    ranking_cop.aggregate_run
    tp ranking_cop.all_rows
  end
end
