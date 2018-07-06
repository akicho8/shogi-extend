#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  user1 = User.create!(race_key: :robot)
  user2 = User.create!(race_key: :robot)
  user1.battle_with(user2)
  user1.battle_with(user2)

  user1.battles.merge(Membership.where.not(fighting_at: nil)).collect(&:id) # => [71, 72]

  tp User

end
# >> I, [2018-07-02T18:46:21.142045 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (1902.59ms)
# >> I, [2018-07-02T18:46:21.153460 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.33ms)
# >> I, [2018-07-02T18:46:21.193103 #19832]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (3.64ms)
# >> I, [2018-07-02T18:46:21.196613 #19832]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (0.86ms)
# >> I, [2018-07-02T18:46:21.201735 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.62ms)
# >> I, [2018-07-02T18:46:21.206413 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.48ms)
# >> I, [2018-07-02T18:46:21.252345 #19832]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (1.1ms)
# >> I, [2018-07-02T18:46:21.258544 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.77ms)
# >> I, [2018-07-02T18:46:21.266115 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.69ms)
# >> I, [2018-07-02T18:46:21.279989 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (4.41ms)
# >> I, [2018-07-02T18:46:21.298238 #19832]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (7.09ms)
# >> I, [2018-07-02T18:46:21.304335 #19832]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (1.01ms)
# >> I, [2018-07-02T18:46:21.310934 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.79ms)
# >> I, [2018-07-02T18:46:21.318658 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (2.68ms)
# >> I, [2018-07-02T18:46:21.333246 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.06ms)
# >> I, [2018-07-02T18:46:21.347146 #19832]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (2.08ms)
# >> I, [2018-07-02T18:46:21.528072 #19832]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (7.93ms)
# >> I, [2018-07-02T18:46:21.540165 #19832]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (2.84ms)
# >> I, [2018-07-02T18:46:21.544172 #19832]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (1.03ms)
# >> I, [2018-07-02T18:46:21.551133 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (3.94ms)
# >> I, [2018-07-02T18:46:21.557659 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (3.49ms)
# >> I, [2018-07-02T18:46:21.582594 #19832]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (0.98ms)
# >> I, [2018-07-02T18:46:21.593032 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (3.31ms)
# >> I, [2018-07-02T18:46:21.602900 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (3.67ms)
# >> I, [2018-07-02T18:46:21.617908 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (6.29ms)
# >> I, [2018-07-02T18:46:21.634607 #19832]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (7.34ms)
# >> I, [2018-07-02T18:46:21.640859 #19832]  INFO -- : Rendered Fanta::ChatMessageSerializer with ActiveModelSerializers::Adapter::Attributes (1.0ms)
# >> I, [2018-07-02T18:46:21.650809 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (3.54ms)
# >> I, [2018-07-02T18:46:21.660958 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (3.62ms)
# >> I, [2018-07-02T18:46:21.674520 #19832]  INFO -- : Rendered Fanta::OnlineUserSerializer with ActiveModelSerializers::Adapter::Attributes (5.26ms)
# >> I, [2018-07-02T18:46:21.686507 #19832]  INFO -- : Rendered Fanta::BattleEachSerializer with ActiveModelSerializers::Adapter::Attributes (1.21ms)
# >> I, [2018-07-02T18:46:21.703755 #19832]  INFO -- : Rendered ActiveModel::Serializer::CollectionSerializer with ActiveModelSerializers::Adapter::Attributes (8.05ms)
# >> |----+----------------------------------+---------+-------------------+---------------------------+---------------------------+-------------+---------------+--------------------------------------------------------------------------------------------------------------------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | id | key                              | name    | current_battle_id | online_at                 | fighting_at               | matching_at | cpu_brain_key | user_agent                                                                                                               | lifetime_key | team_key   | self_preset_key | oppo_preset_key | robot_accept_key | race_key | created_at                | updated_at                |
# >> |----+----------------------------------+---------+-------------------+---------------------------+---------------------------+-------------+---------------+--------------------------------------------------------------------------------------------------------------------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | 42 | cee13690b52c614d958d8229d04347c7 | CPU1号  |                66 | 2018-07-02 18:33:29 +0900 | 2018-07-02 18:33:31 +0900 |             |               |                                                                                                                          | lifetime_m5  | team_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-02 18:33:29 +0900 | 2018-07-02 18:33:31 +0900 |
# >> | 43 | 1bb6726f193e2e2126a52f2eb39af89b | CPU2号  |                66 | 2018-07-02 18:33:31 +0900 | 2018-07-02 18:33:31 +0900 |             |               |                                                                                                                          | lifetime_m5  | team_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-02 18:33:31 +0900 | 2018-07-02 18:33:31 +0900 |
# >> | 44 | c18b2e8c8e665c4577a569b9a8b87677 | 野良1号 |                   | 2018-07-02 18:42:25 +0900 |                           |             |               | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.87 Safari/537.36 | lifetime_m5  | team_p1vs1 | 平手            | 平手            | not_accept       | human    | 2018-07-02 18:33:51 +0900 | 2018-07-02 18:44:02 +0900 |
# >> | 45 | c6fce4cd5e81ac9e963424b4b5a0adff | CPU3号  |                68 | 2018-07-02 18:37:00 +0900 | 2018-07-02 18:37:02 +0900 |             |               |                                                                                                                          | lifetime_m5  | team_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-02 18:37:00 +0900 | 2018-07-02 18:37:02 +0900 |
# >> | 46 | af0731d022e9893eeecc235c56f19621 | CPU4号  |                68 | 2018-07-02 18:37:02 +0900 | 2018-07-02 18:37:02 +0900 |             |               |                                                                                                                          | lifetime_m5  | team_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-02 18:37:02 +0900 | 2018-07-02 18:37:02 +0900 |
# >> | 47 | 243338ae11afda89f19b87f57304b35b | CPU5号  |                70 | 2018-07-02 18:44:57 +0900 | 2018-07-02 18:44:59 +0900 |             |               |                                                                                                                          | lifetime_m5  | team_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-02 18:44:57 +0900 | 2018-07-02 18:44:59 +0900 |
# >> | 48 | 9d26e14fce004635acf27b384ab143c3 | CPU6号  |                70 | 2018-07-02 18:44:59 +0900 | 2018-07-02 18:44:59 +0900 |             |               |                                                                                                                          | lifetime_m5  | team_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-02 18:44:59 +0900 | 2018-07-02 18:44:59 +0900 |
# >> | 49 | 2cadc606d74bd5416332b15f8483b7fe | CPU7号  |                72 | 2018-07-02 18:46:19 +0900 | 2018-07-02 18:46:21 +0900 |             |               |                                                                                                                          | lifetime_m5  | team_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-02 18:46:19 +0900 | 2018-07-02 18:46:21 +0900 |
# >> | 50 | a00e050b8f1e72eaa4fbfc2a530ed527 | CPU8号  |                72 | 2018-07-02 18:46:21 +0900 | 2018-07-02 18:46:21 +0900 |             |               |                                                                                                                          | lifetime_m5  | team_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-02 18:46:21 +0900 | 2018-07-02 18:46:21 +0900 |
# >> |----+----------------------------------+---------+-------------------+---------------------------+---------------------------+-------------+---------------+--------------------------------------------------------------------------------------------------------------------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
