module Colosseum
  class RankingInfo
    include ApplicationMemoryRecord
    memory_record [
      { key: :total, name: "総合", begin_at: nil,                                    end_at: nil,                                               },
      { key: :day,   name: "本日", begin_at: -> { Time.current.midnight           }, end_at: -> { Time.current.midnight.tomorrow },             },
      { key: :week,  name: "週間", begin_at: -> { Time.current.beginning_of_week  }, end_at: -> { Time.current.beginning_of_week.next_week },   },
      { key: :month, name: "月間", begin_at: -> { Time.current.beginning_of_month }, end_at: -> { Time.current.beginning_of_month.next_month }, },
    ]

    cattr_accessor(:rank_limit) { 50 }  # 位まで表示
    cattr_accessor(:accuracy)  { 1000 } # 精度

    def all
      current_clean
      aggregate
      redis.zrevrange(inside_key, 0, rank_limit - 1, with_scores: true).collect do |user_id, score|
        rank = redis.zcount(inside_key, score + 1, "+inf") + 1
        {rank: rank, user_id: user_id, win_ratio: score.fdiv(accuracy)}
      end
    end

    private

    def aggregate
      win_ratio_scope.each do |row|
        redis.zadd(inside_key, row["win_ratio"], row["user_id"])
      end
    end

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
      ActiveRecord::Base.connection.select_all("
        SELECT user_id, FLOOR((win * #{accuracy}) / (win + lose)) AS win_ratio
        FROM (#{chronicle_scope.to_sql}) AS chronicles
        ORDER BY win_ratio DESC")
    end

    def chronicle_scope
      scope = Chronicle.all

      if begin_at && end_at
        scope = scope.where(created_at: begin_at.call...end_at.call)
      end

      scope = scope.select("
        user_id,
        SUM(CASE WHEN judge_key = 'win'  THEN 1 ELSE 0 END) AS win,
        SUM(CASE WHEN judge_key = 'lose' THEN 1 ELSE 0 END) AS lose")

      scope = scope.group("user_id")
    end
  end
end
