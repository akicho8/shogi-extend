#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Colosseum
  Chronicle.destroy_all
  User.destroy_all

  user = User.create!

  user = User.create!
  user.judge_add(:win)
  user.judge_add(:lose)

  user = User.create!
  user.judge_add(:win)
  user.judge_add(:win)

  user = User.create!
  user.judge_add(:win)
  user.judge_add(:win)

  ActiveSupport::LogSubscriber.colorize_logging = false
  ActiveRecord::Base.logger = ActiveSupport::Logger.new(STDOUT)
  RankingInfo.each do |e|
    tp e.all
  end
end
# >>    (0.6ms)  
# >>       select user_id, floor(win / (win + lose) * 1000) as win_ratio
# >>       from (SELECT user_id, sum(case when judge_key = 'win' then 1 else 0 end) as win, sum(case when judge_key='lose' then 1 else 0 end) as lose FROM `colosseum_chronicles` GROUP BY `colosseum_chronicles`.`user_id`) as chronicles
# >>       order by win_ratio desc
# >>   ↳ app/models/colosseum/ranking_info.rb:44
# >> |------+---------+-----------|
# >> | rank | user_id | win_ratio |
# >> |------+---------+-----------|
# >> |    1 |      55 |       1.0 |
# >> |    1 |      54 |       1.0 |
# >> |    3 |      53 |       0.5 |
# >> |------+---------+-----------|
# >>    (0.6ms)  
# >>       select user_id, floor(win / (win + lose) * 1000) as win_ratio
# >>       from (SELECT user_id, sum(case when judge_key = 'win' then 1 else 0 end) as win, sum(case when judge_key='lose' then 1 else 0 end) as lose FROM `colosseum_chronicles` WHERE `colosseum_chronicles`.`created_at` >= '2018-07-23 15:00:00' AND `colosseum_chronicles`.`created_at` < '2018-07-24 15:00:00' GROUP BY `colosseum_chronicles`.`user_id`) as chronicles
# >>       order by win_ratio desc
# >>   ↳ app/models/colosseum/ranking_info.rb:44
# >> |------+---------+-----------|
# >> | rank | user_id | win_ratio |
# >> |------+---------+-----------|
# >> |    1 |      55 |       1.0 |
# >> |    1 |      54 |       1.0 |
# >> |    3 |      53 |       0.5 |
# >> |------+---------+-----------|
# >>    (0.5ms)  
# >>       select user_id, floor(win / (win + lose) * 1000) as win_ratio
# >>       from (SELECT user_id, sum(case when judge_key = 'win' then 1 else 0 end) as win, sum(case when judge_key='lose' then 1 else 0 end) as lose FROM `colosseum_chronicles` WHERE `colosseum_chronicles`.`created_at` >= '2018-07-22 15:00:00' AND `colosseum_chronicles`.`created_at` < '2018-07-29 15:00:00' GROUP BY `colosseum_chronicles`.`user_id`) as chronicles
# >>       order by win_ratio desc
# >>   ↳ app/models/colosseum/ranking_info.rb:44
# >> |------+---------+-----------|
# >> | rank | user_id | win_ratio |
# >> |------+---------+-----------|
# >> |    1 |      55 |       1.0 |
# >> |    1 |      54 |       1.0 |
# >> |    3 |      53 |       0.5 |
# >> |------+---------+-----------|
# >>    (0.6ms)  
# >>       select user_id, floor(win / (win + lose) * 1000) as win_ratio
# >>       from (SELECT user_id, sum(case when judge_key = 'win' then 1 else 0 end) as win, sum(case when judge_key='lose' then 1 else 0 end) as lose FROM `colosseum_chronicles` WHERE `colosseum_chronicles`.`created_at` >= '2018-06-30 15:00:00' AND `colosseum_chronicles`.`created_at` < '2018-07-31 15:00:00' GROUP BY `colosseum_chronicles`.`user_id`) as chronicles
# >>       order by win_ratio desc
# >>   ↳ app/models/colosseum/ranking_info.rb:44
# >> |------+---------+-----------|
# >> | rank | user_id | win_ratio |
# >> |------+---------+-----------|
# >> |    1 |      55 |       1.0 |
# >> |    1 |      54 |       1.0 |
# >> |    3 |      53 |       0.5 |
# >> |------+---------+-----------|
