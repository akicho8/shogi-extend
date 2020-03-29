#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Colosseum
  User.destroy_all
  Battle.destroy_all

  user0 = User.create!(name: "人間0", team_key: :team_p2vs2, self_preset_key: "平手", oppo_preset_key: "飛車落ち", robot_accept_key: :not_accept) # 人間とだけ対戦したい人
  user1 = User.create!(name: "人間1", team_key: :team_p2vs2, self_preset_key: "平手", oppo_preset_key: "飛車落ち")                                # CPUとも対戦可
  user2 = User.create!(name: "人間2", team_key: :team_p2vs2, self_preset_key: "飛車落ち", oppo_preset_key: "平手")                                # CPUとも対戦可
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
# >> |---------------------+-----------------------------------------------------------------------------|
# >> |                  id | 83                                                                          |
# >> |    black_preset_key | 平手                                                                        |
# >> |    white_preset_key | 飛車落ち                                                                    |
# >> |        lifetime_key | lifetime_m5                                                                 |
# >> |         team_key | team_p2vs2                                                               |
# >> |           full_sfen | position sfen lnsgkgsnl/7b1/ppppppppp/9/9/9/PPPPPPPPP/1B5R1/LNSGKGSNL w - 1 |
# >> |        clock_counts | {:black=>[], :white=>[]}                                                    |
# >> |     countdown_flags | {:black=>false, :white=>false}                                              |
# >> |            turn_max | 0                                                                           |
# >> |   battle_request_at |                                                                             |
# >> |     auto_matched_at | 2018-07-04 15:03:04 +0900                                                   |
# >> |            begin_at |                                                                             |
# >> |              end_at |                                                                             |
# >> |     last_action_key |                                                                             |
# >> |    win_location_key |                                                                             |
# >> | current_users_count | 0                                                                           |
# >> |   watch_ships_count | 0                                                                           |
# >> |          created_at | 2018-07-04 15:03:04 +0900                                                   |
# >> |          updated_at | 2018-07-04 15:03:04 +0900                                                   |
# >> |---------------------+-----------------------------------------------------------------------------|
# >> |-------|
# >> | CPU   |
# >> | CPU   |
# >> | 人間1 |
# >> | 人間2 |
# >> |-------|
# >> |-----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | id  | key                              | name  | joined_at                 | fighting_at               | matching_at               | cpu_brain_key | user_agent | lifetime_key | team_key   | self_preset_key | oppo_preset_key | robot_accept_key | race_key | created_at                | updated_at                |
# >> |-----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
# >> | 118 | 7c54762cb59b8224423f71db3d16f2dd | 人間0 | 2018-07-04 15:03:04 +0900 |                           | 2018-07-04 15:03:04 +0900 |               |            | lifetime_m5  | team_p2vs2 | 平手            | 飛車落ち        | not_accept       | human    | 2018-07-04 15:03:04 +0900 | 2018-07-04 15:03:04 +0900 |
# >> | 119 | ab2a47fec4982e0c766d2cbe251cd535 | 人間1 | 2018-07-04 15:03:04 +0900 |                           |                           |               |            | lifetime_m5  | team_p2vs2 | 平手            | 飛車落ち        | accept           | human    | 2018-07-04 15:03:04 +0900 | 2018-07-04 15:03:04 +0900 |
# >> | 120 | 183f0f14e4e227e2648838995254cb66 | 人間2 | 2018-07-04 15:03:04 +0900 |                           |                           |               |            | lifetime_m5  | team_p2vs2 | 飛車落ち        | 平手            | accept           | human    | 2018-07-04 15:03:04 +0900 | 2018-07-04 15:03:04 +0900 |
# >> | 121 | 47b594e9376e6219a47d091743dd2c44 | CPU   | 2018-07-04 15:03:04 +0900 | 2018-07-04 15:03:05 +0900 |                           |               |            | lifetime_m5  | team_p1vs1 | 平手            | 平手            | accept           | robot    | 2018-07-04 15:03:04 +0900 | 2018-07-04 15:03:05 +0900 |
# >> |-----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+--------------+---------------+-----------------+-----------------+------------------+----------+---------------------------+---------------------------|
