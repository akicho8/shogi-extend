#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  User.destroy_all
  Battle.destroy_all

  user1 = User.create!
  user2 = User.create!(race_key: :robot)
  user1.matching_start
  tp User
end
# >> I, [2018-07-02T14:32:02.135907 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1968.69ms)
# >> I, [2018-07-02T14:32:02.148326 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.18ms)
# >> I, [2018-07-02T14:32:02.163573 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (3.05ms)
# >> I, [2018-07-02T14:32:02.174895 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.04ms)
# >> I, [2018-07-02T14:32:02.186232 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.39ms)
# >> I, [2018-07-02T14:32:02.197432 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.18ms)
# >> I, [2018-07-02T14:32:02.210747 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.64ms)
# >> I, [2018-07-02T14:32:02.221804 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.19ms)
# >> I, [2018-07-02T14:32:02.231658 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.08ms)
# >> I, [2018-07-02T14:32:02.241314 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.17ms)
# >> I, [2018-07-02T14:32:02.263793 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.32ms)
# >> I, [2018-07-02T14:32:02.275198 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.35ms)
# >> I, [2018-07-02T14:32:02.707636 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.13ms)
# >> I, [2018-07-02T14:32:02.720472 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.1ms)
# >> I, [2018-07-02T14:32:02.727711 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (1.23ms)
# >> I, [2018-07-02T14:32:02.773267 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.21ms)
# >> I, [2018-07-02T14:32:02.777547 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.15ms)
# >> I, [2018-07-02T14:32:02.842766 #5879]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (1.13ms)
# >> I, [2018-07-02T14:32:02.847334 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (0.89ms)
# >> I, [2018-07-02T14:32:02.856550 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (3.92ms)
# >> I, [2018-07-02T14:32:02.872420 #5879]  INFO -- : Rendered Fanta::ChatUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.6ms)
# >> I, [2018-07-02T14:32:02.892689 #5879]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (8.34ms)
# >> |----+----------------------------------+---------+-------------------+---------------------------+---------------------------+-------------+--------------+---------------+-----------------+-----------------+------------+----------+---------------+---------------------------+---------------------------|
# >> | id | key                              | name    | current_battle_id | online_at                 | fighting_at               | matching_at | lifetime_key | platoon_key   | self_preset_key | oppo_preset_key | user_agent | race_key | cpu_brain_key | created_at                | updated_at                |
# >> |----+----------------------------------+---------+-------------------+---------------------------+---------------------------+-------------+--------------+---------------+-----------------+-----------------+------------+----------+---------------+---------------------------+---------------------------|
# >> | 54 | 46ae188fafe58fc6a6c8825615da1b54 | 野良1号 |                   | 2018-07-02 14:32:02 +0900 |                           |             | lifetime_m5  | platoon_p1vs1 | 平手            | 平手            |            | human    |               | 2018-07-02 14:32:02 +0900 | 2018-07-02 14:32:02 +0900 |
# >> | 55 | 7e32a4141c5da0632694e2ecd8c86bfc | CPU1号  |                51 | 2018-07-02 14:32:02 +0900 | 2018-07-02 14:32:02 +0900 |             | lifetime_m5  | platoon_p1vs1 | 平手            | 平手            |            | robot    |               | 2018-07-02 14:32:02 +0900 | 2018-07-02 14:32:02 +0900 |
# >> |----+----------------------------------+---------+-------------------+---------------------------+---------------------------+-------------+--------------+---------------+-----------------+-----------------+------------+----------+---------------+---------------------------+---------------------------|
