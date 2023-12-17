require "rails_helper"

module ShareBoard
  RSpec.describe Dashboard do
    it "call" do
      room = Room.create!
      room.redis_clear
      room.battles.create! do |e|
        e.memberships.build([
                              { user_name: "alice", location_key: "black", judge_key: "win",  },
                              { user_name: "bob",   location_key: "white", judge_key: "lose", },
                            ])
      end
      json = Dashboard.new(room_key: "dev_room").call
      assert { json }
      tp json if $0 == __FILE__
    end
  end
end
