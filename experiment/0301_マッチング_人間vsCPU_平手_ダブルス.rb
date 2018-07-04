#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  User.destroy_all
  Battle.destroy_all

  user0 = User.create!(name: "人間0", platoon_key: :platoon_p2vs2, robot_accept_key: :not_accept) # 人間とだけ対戦したい人
  user1 = User.create!(name: "人間1", platoon_key: :platoon_p2vs2)                                # CPUとも対戦可
  user2 = User.create!(name: "人間2", platoon_key: :platoon_p2vs2)                                # CPUとも対戦可
  user3 = User.create!(name: "CPU", race_key: :robot)

  # 人との対戦希望でマッチング開始
  user0.matching_start          # => nil
  user1.matching_start          # => nil
  user2.matching_start          # => nil

  # 人間1がCPUも含めてマッチング開始
  battle = user1.matching_start(with_robot: true)

  tp battle
  tp battle.users.collect(&:name).sort # => ["CPU", "CPU", "人間1", "人間2"]
  tp User
end
# >> |-------------------+-------------------------------------------------------------------------------|
# >> |                id | 51                                                                            |
# >> |  black_preset_key | 平手                                                                          |
# >> |  white_preset_key | 平手                                                                          |
# >> |      lifetime_key | lifetime_m5                                                                   |
# >> |       platoon_key | platoon_p2vs2                                                                 |
# >> |         full_sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |      clock_counts | {:black=>[], :white=>[]}                                                      |
# >> |   countdown_flags | {:black=>false, :white=>false}                                                |
# >> |          turn_max | 0                                                                             |
# >> | battle_request_at |                                                                               |
# >> |   auto_matched_at | 2018-07-04 17:17:15 +0900                                                     |
# >> |          begin_at |                                                                               |
# >> |            end_at |                                                                               |
# >> |   last_action_key |                                                                               |
# >> |  win_location_key |                                                                               |
# >> | memberships_count | 4                                                                             |
# >> | watch_ships_count | 0                                                                             |
# >> |        created_at | 2018-07-04 17:17:15 +0900                                                     |
# >> |        updated_at | 2018-07-04 17:17:15 +0900                                                     |
# >> |-------------------+-------------------------------------------------------------------------------|
# >> |-------|
# >> | CPU   |
# >> | CPU   |
# >> | 人間1 |
# >> | 人間2 |
# >> |-------|
# >> |----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | id | key                              | name  | online_at                 | fighting_at               | matching_at               | cpu_brain_key | user_agent | lifetime_key | platoon_key   | self_preset_key | oppo_preset_key | robot_accept_key | race_key | created_at                | updated_at                |
# >> |----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | 13 | 0fdc5cafcfffbf80cbed5dd0753b1d36 | 人間0 | 2018-07-04 17:17:15 +0900 |                           | 2018-07-04 17:17:15 +0900 |               |            | lifetime_m5  | platoon_p2vs2 | 平手            | 平手            | not_accept       | human    | 2018-07-04 17:17:15 +0900 | 2018-07-04 17:17:15 +0900 |
# >> | 14 | 0d6c8e43f4eaec50afa1367ee7d1c585 | 人間1 | 2018-07-04 17:17:15 +0900 |                           |                           |               |            | lifetime_m5  | platoon_p2vs2 | 平手            | 平手            | accept           | human    | 2018-07-04 17:17:15 +0900 | 2018-07-04 17:17:15 +0900 |
# >> | 15 | 9feeb32632ca93690aca305fd3600805 | 人間2 | 2018-07-04 17:17:15 +0900 |                           |                           |               |            | lifetime_m5  | platoon_p2vs2 | 平手            | 平手            | accept           | human    | 2018-07-04 17:17:15 +0900 | 2018-07-04 17:17:15 +0900 |
# >> | 16 | 2af0f58068d1433df00de4ce3782b0ee | CPU   | 2018-07-04 17:17:15 +0900 | 2018-07-04 17:17:15 +0900 |                           |               |            | lifetime_m5  | platoon_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-04 17:17:15 +0900 | 2018-07-04 17:17:15 +0900 |
# >> |----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
