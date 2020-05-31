require "rails_helper"

RSpec.describe Actb::RoomChannel, type: :channel do
  before(:context) do
    Actb.setup
  end

  let_it_be(:user1) { Colosseum::User.create! }
  let_it_be(:user2) { Colosseum::User.create! }

  before do
    Actb::BaseChannel.redis.flushdb
    stub_connection current_user: user1
  end

  let_it_be(:current_room) do
    Actb::Room.create_with_members!([user1, user2])
  end

  describe "#subscribe" do
    it "接続" do
      expect { subscribe(room_id: current_room.id) }.to have_broadcasted_to("actb/school_channel").with(bc_action: "online_status_broadcasted", bc_params: {room_user_ids: [user1.id]})
      assert { subscription.confirmed? }
      assert { subscription.room_users == [user1] }
    end

    it "部屋に入ると対局準備" do
      expect { subscribe(room_id: current_room.id) }.to have_broadcasted_to("actb/room_channel/#{current_room.id}")
    end
  end

  describe "#unsubscribe" do
    before do
      subscribe(room_id: current_room.id)
    end

    it "退室" do
      assert { subscription.room_users == [user1] }
      unsubscribe
      assert { subscription.room_users == [] }
    end

    it "人数通知" do
      expect { unsubscribe }.to have_broadcasted_to("actb/school_channel").exactly(1)
    end
  end
end
