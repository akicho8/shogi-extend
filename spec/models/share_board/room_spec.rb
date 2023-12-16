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

module ShareBoard
  RSpec.describe Room do
    it "works" do
      room = Room.create!
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
end
