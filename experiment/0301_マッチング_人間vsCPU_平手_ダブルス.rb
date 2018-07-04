#!/usr/bin/env ruby
require File.expand_path('../../config/environment', __FILE__)

module Fanta
  User.destroy_all
  Battle.destroy_all

  user0 = User.create!(name: "人間0", rule_attributes: {platoon_key: :platoon_p2vs2, robot_accept_key: :not_accept}) # 人間とだけ対戦したい人
  user1 = User.create!(name: "人間1", rule_attributes: {platoon_key: :platoon_p2vs2})                                # CPUとも対戦可
  user2 = User.create!(name: "人間2", rule_attributes: {platoon_key: :platoon_p2vs2})                                # CPUとも対戦可
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
# >> |   auto_matched_at | 2018-07-04 18:32:30 +0900                                                     |
# >> |          begin_at |                                                                               |
# >> |            end_at |                                                                               |
# >> |   last_action_key |                                                                               |
# >> |  win_location_key |                                                                               |
# >> | memberships_count | 4                                                                             |
# >> | watch_ships_count | 0                                                                             |
# >> |        created_at | 2018-07-04 18:32:30 +0900                                                     |
# >> |        updated_at | 2018-07-04 18:32:30 +0900                                                     |
# >> |-------------------+-------------------------------------------------------------------------------|
# >> |-------|
# >> | CPU   |
# >> | CPU   |
# >> | 人間1 |
# >> | 人間2 |
# >> |-------|
# >> |----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+----------+---------------------------+---------------------------|
# >> | id | key                              | name  | online_at                 | fighting_at               | matching_at               | cpu_brain_key | user_agent | race_key | created_at                | updated_at                |
# >> |----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+----------+---------------------------+---------------------------|
# >> | 23 | 9e66d174ac276739a11bbb57afa01220 | 人間0 | 2018-07-04 18:32:30 +0900 |                           | 2018-07-04 18:32:30 +0900 |               |            | human    | 2018-07-04 18:32:30 +0900 | 2018-07-04 18:32:30 +0900 |
# >> | 24 | 6cd55a1881c3360fd238d61548c28442 | 人間1 | 2018-07-04 18:32:30 +0900 |                           |                           |               |            | human    | 2018-07-04 18:32:30 +0900 | 2018-07-04 18:32:30 +0900 |
# >> | 25 | e2b70b66ec8fcea7f2cb64bdc3f16ff2 | 人間2 | 2018-07-04 18:32:30 +0900 |                           |                           |               |            | human    | 2018-07-04 18:32:30 +0900 | 2018-07-04 18:32:30 +0900 |
# >> | 26 | 09547e1e2eece2a9191405bcadee9864 | CPU   | 2018-07-04 18:32:30 +0900 | 2018-07-04 18:32:30 +0900 |                           |               |            | robot    | 2018-07-04 18:32:30 +0900 | 2018-07-04 18:32:30 +0900 |
# >> |----+----------------------------------+-------+---------------------------+---------------------------+---------------------------+---------------+------------+----------+---------------------------+---------------------------|
