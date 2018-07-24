#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Colosseum
  User.destroy_all

  user = User.create!

  user = User.create!
  user.judge_add(:win)
  user.judge_add(:lose)

  user = User.create!
  user.judge_add(:win)
  user.judge_add(:win)

  tp Chronicle.all

  chronicle_scope = Chronicle.select("user_id, sum(case when judge_key = 'win' then 1 else 0 end) as win, sum(case when judge_key='lose' then 1 else 0 end) as lose").group("user_id")
  rows = ActiveRecord::Base.connection.select_all("select user_id, floor(win / (win + lose) * 1000) as win_ratio from (#{chronicle_scope.to_sql}) as chronicles order by win_ratio desc")

  redis = Redis.new(host: "localhost", port: 6379, db: 1)
  pp redis

  redis.del("foo")
  rows.each do |row|
    p [row["win_ratio"], row["user_id"]] # => [1000, 16], [500, 15]
    redis.zadd("foo", row["win_ratio"], row["user_id"])
  end

  ranking = redis.zrevrange("foo", 0, -1, with_scores: true) # 0, -1 は 0以上のすべて
  ranking.each do |user_id, score|
    rank = redis.zcount("foo", score + 1, "+inf") + 1 # 表示ランク取得処理は重いので表示する直前で調べた方が良い
    p({rank: rank, user_id: user_id, score: score})
  end
end
# >> |----+---------+-----------+---------------------------+---------------------------|
# >> | id | user_id | judge_key | created_at                | updated_at                |
# >> |----+---------+-----------+---------------------------+---------------------------|
# >> |  1 |      15 | win       | 2018-07-24 13:05:34 +0900 | 2018-07-24 13:05:34 +0900 |
# >> |  2 |      15 | lose      | 2018-07-24 13:05:34 +0900 | 2018-07-24 13:05:34 +0900 |
# >> |  3 |      16 | win       | 2018-07-24 13:05:35 +0900 | 2018-07-24 13:05:35 +0900 |
# >> |  4 |      16 | win       | 2018-07-24 13:05:35 +0900 | 2018-07-24 13:05:35 +0900 |
# >> |----+---------+-----------+---------------------------+---------------------------|
# >> #<Redis client v3.3.5 for redis://localhost:6379/1>
# >> [1000, 16]
# >> [500, 15]
# >> {:rank=>1, :user_id=>"16", :score=>1000.0}
# >> {:rank=>2, :user_id=>"15", :score=>500.0}
