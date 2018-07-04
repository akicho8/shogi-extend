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
  battle = user1.matching_start_with_robot

  tp battle
  tp battle.users.collect(&:name).sort # => ["CPU", "CPU", "人間1", "人間2"]
  tp User
end
# >> |---------------------+-------------------------------------------------------------------------------|
# >> |                  id | 82                                                                            |
# >> |    black_preset_key | 平手                                                                          |
# >> |    white_preset_key | 平手                                                                          |
# >> |        lifetime_key | lifetime_m5                                                                   |
# >> |         platoon_key | platoon_p2vs2                                                                 |
# >> |           full_sfen | position sfen lnsgkgsnl/1r5b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL b - 1 |
# >> |        clock_counts | {:black=>[], :white=>[]}                                                      |
# >> |     countdown_flags | {:black=>false, :white=>false}                                                |
# >> |            turn_max | 0                                                                             |
# >> |   battle_request_at |                                                                               |
# >> |     auto_matched_at | 2018-07-04 14:37:07 +0900                                                     |
# >> |            begin_at |                                                                               |
# >> |              end_at |                                                                               |
# >> |     last_action_key |                                                                               |
# >> |    win_location_key |                                                                               |
# >> | current_users_count | 0                                                                             |
# >> |   watch_ships_count | 0                                                                             |
# >> |          created_at | 2018-07-04 14:37:07 +0900                                                     |
# >> |          updated_at | 2018-07-04 14:37:07 +0900                                                     |
# >> |---------------------+-------------------------------------------------------------------------------|
# >> |-------|
# >> | CPU   |
# >> | CPU   |
# >> | 人間1 |
# >> | 人間2 |
# >> |-------|
# >> |-----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | id  | key                              | name  | online_at                 | fighting_at               | matching_at               | cpu_brain_key | user_agent | lifetime_key | platoon_key   | self_preset_key | oppo_preset_key | robot_accept_key | race_key | created_at                | updated_at                |
# >> |-----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | 110 | 6e2661daaba76411db68b10470aac8dc | 人間0 | 2018-07-04 14:37:07 +0900 |                           | 2018-07-04 14:37:07 +0900 |               |            | lifetime_m5  | platoon_p2vs2 | 平手            | 平手            | not_accept       | human    | 2018-07-04 14:37:07 +0900 | 2018-07-04 14:37:07 +0900 |
# >> | 111 | 59af2aed4f0ef5b86e1d64512abe710b | 人間1 | 2018-07-04 14:37:07 +0900 |                           |                           |               |            | lifetime_m5  | platoon_p2vs2 | 平手            | 平手            | accept           | human    | 2018-07-04 14:37:07 +0900 | 2018-07-04 14:37:07 +0900 |
# >> | 112 | ccb5e2ddc08237f0cfc9ed6ad25e62ae | 人間2 | 2018-07-04 14:37:07 +0900 |                           |                           |               |            | lifetime_m5  | platoon_p2vs2 | 平手            | 平手            | accept           | human    | 2018-07-04 14:37:07 +0900 | 2018-07-04 14:37:07 +0900 |
# >> | 113 | 8f9281fb7819ffa00e2beaf10d8a1d16 | CPU   | 2018-07-04 14:37:07 +0900 | 2018-07-04 14:37:07 +0900 |                           |               |            | lifetime_m5  | platoon_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-04 14:37:07 +0900 | 2018-07-04 14:37:07 +0900 |
# >> |-----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
