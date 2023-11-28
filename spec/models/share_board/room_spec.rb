# -*- coding: utf-8 -*-
# == Schema Information ==
#
# Room (share_board_rooms as ShareBoard::Room)
#
# |---------------+---------------+-------------+-------------+------+-------|
# | name          | desc          | type        | opts        | refs | index |
# |---------------+---------------+-------------+-------------+------+-------|
# | id            | ID            | integer(8)  | NOT NULL PK |      |       |
# | key           | キー          | string(255) | NOT NULL    |      | A!    |
# | battles_count | Battles count | integer(4)  | DEFAULT(0)  |      |       |
# | created_at    | 作成日時      | datetime    | NOT NULL    |      |       |
# | updated_at    | 更新日時      | datetime    | NOT NULL    |      |       |
# |---------------+---------------+-------------+-------------+------+-------|

require "rails_helper"

RSpec.describe ShareBoard::Room do
  it "works" do
    room = ShareBoard::Room.create!
    room.redis_clear

    2.times do |i|
      room.battles.create! do |e|
        e.memberships.build([
            { user_name: "alice", location_key: "black", judge_key: "win",  },
            { user_name: "bob",   location_key: "white", judge_key: "lose", },
            { user_name: "carol", location_key: "black", judge_key: "win",  },
          ])
      end
    end

    room.reload
    assert { room.roomships.collect(&:rank) === [1, 1, 3] }
    tp room.roomships if $0 == __FILE__
  end
end
# >> Run options: exclude {:login_spec=>true, :slow_spec=>true}
# >> 
# >> ShareBoard::Room
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------|
# >> | id | room_id | user_id | win_count | lose_count | battles_count | win_rate | score | rank | created_at                | updated_at                |
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------|
# >> | 33 |      23 |      33 |         2 |          0 |             2 |      1.0 |     2 |    1 | 2023-11-26 15:17:18 +0900 | 2023-11-26 15:17:18 +0900 |
# >> | 35 |      23 |      35 |         2 |          0 |             2 |      1.0 |     2 |    1 | 2023-11-26 15:17:18 +0900 | 2023-11-26 15:17:18 +0900 |
# >> | 34 |      23 |      34 |         0 |          2 |             2 |      0.0 |     0 |    3 | 2023-11-26 15:17:18 +0900 | 2023-11-26 15:17:18 +0900 |
# >> |----+---------+---------+-----------+------------+---------------+----------+-------+------+---------------------------+---------------------------|
# >>   works
# >> 
# >> Top 1 slowest examples (0.46153 seconds, 18.1% of total time):
# >>   ShareBoard::Room works
# >>     0.46153 seconds -:19
# >> 
# >> Finished in 2.55 seconds (files took 2.56 seconds to load)
# >> 1 example, 0 failures
# >> 
