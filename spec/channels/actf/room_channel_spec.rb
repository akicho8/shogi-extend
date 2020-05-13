require "rails_helper"

RSpec.describe Actf::RoomChannel, type: :channel do
  let_it_be(:user1) { Colosseum::User.create! }
  let_it_be(:user2) { Colosseum::User.create! }

  before do
    Actf::SchoolChannel.redis.flushdb

    stub_connection current_user: user1
  end

  let_it_be(:current_room) do
    Actf::Room.create! do |e|
      e.memberships.build(user: user1)
      e.memberships.build(user: user2)
    end
  end

  def membership1
    current_room.memberships.find { |e| e.user == user1 }
  end

  def membership2
    current_room.memberships.find { |e| e.user == user2 }
  end

  describe "#subscribe" do
    it "接続" do
      expect { subscribe(room_id: current_room.id) }.to have_broadcasted_to("actf/school_channel").with(room_user_ids: [user1.id])
      assert { subscription.confirmed? }
      assert { subscription.room_users == [user1] }
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
      expect { unsubscribe }.to have_broadcasted_to("actf/school_channel").twice
    end

    it "切断したので負け" do
      unsubscribe
      assert { membership1.judge_key == "lose" }
    end
  end

  describe "#speak" do
    before do
      subscribe(room_id: current_room.id)
    end

    it do
      subscription.speak(message: "(message)")
      assert { user1.actf_messages.count == 1 }
    end
  end

  describe "#correct_hook" do
    before do
      subscribe(room_id: current_room.id)
    end

    it do
      data = { membership_id: membership1.id, quest_index: 1 }
      expect {
        subscription.correct_hook(data)
      }.to have_broadcasted_to("actf/room_channel/#{current_room.id}").with(correct_hook: data)

      current_room.reload
      assert { membership1.quest_index == 1 }
    end
  end

  describe "#katimasitayo" do
    before do
      subscribe(room_id: current_room.id)
    end

    it "結果画面へ" do
      expect {
        subscription.katimasitayo({})
      }.to have_broadcasted_to("actf/room_channel/#{current_room.id}")
    end

    it "対戦中人数を減らして通知" do
      expect {
        subscription.katimasitayo({})
      }.to have_broadcasted_to("actf/school_channel")
    end

    it "結果" do
      subscription.katimasitayo({})
      current_room.reload

      assert { current_room.end_at    }
      assert { current_room.final_key }

      assert { membership1.judge_key == "win"  }
      assert { membership2.judge_key == "lose" }

      assert { user1.reload.rating == 1516 }
      assert { user2.reload.rating == 1484 }
    end
  end
end
