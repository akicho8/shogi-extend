require "rails_helper"

RSpec.describe Emox::BattleChannel, type: :channel do
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

  let_it_be(:current_battle) do
    current_room.battle_create_with_members!
  end

  def membership1
    current_battle.memberships.find { |e| e.user == user1 }
  end

  def membership2
    current_battle.memberships.find { |e| e.user == user2 }
  end

  describe "#subscribe" do
    it "接続" do
      subscribe(battle_id: current_battle.id)
      assert { subscription.confirmed? }
    end
  end

  describe "#unsubscribe" do
    before do
      subscribe(battle_id: current_battle.id)
    end

    it "切断したので負け" do
      unsubscribe
      assert { membership1.judge.key == "lose" }
    end
  end
end
