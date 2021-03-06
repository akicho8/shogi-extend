require "rails_helper"

RSpec.describe Emox::RoomChannel, type: :channel do
  before(:context) do
    Emox.setup
  end

  let_it_be(:user1) { User.create! }
  let_it_be(:user2) { User.create! }

  before do
    Emox::BaseChannel.redis.flushdb
    stub_connection current_user: user1
  end

  let_it_be(:current_room) do
    Emox::Room.create_with_members!([user1, user2])
  end

  describe "#subscribe" do
    it "接続" do
      expect { subscribe(room_id: current_room.id) }.to have_broadcasted_to("emox/school_channel").with(bc_action: "active_users_status_broadcasted", bc_params: {emox_room_user_ids: [user1.id]})
      assert { subscription.confirmed? }
      assert { Emox::RoomChannel.active_users == [user1] }
    end

    it "部屋に入ると対局準備" do
      expect { subscribe(room_id: current_room.id) }.to have_broadcasted_to("emox/room_channel/#{current_room.id}")
    end
  end

  describe "#unsubscribe" do
    before do
      subscribe(room_id: current_room.id)
    end

    it "退室すると対戦中の人が減る" do
      assert { Emox::RoomChannel.active_users == [user1] }
      unsubscribe
      assert { Emox::RoomChannel.active_users == [] }
    end

    it "退室すると人数通知する" do
      expect { unsubscribe }.to have_broadcasted_to("emox/school_channel").exactly(1)
    end

    it "退室すると終了時間が入る" do
      unsubscribe
      assert { current_room.reload.end_at }
    end
  end
end
