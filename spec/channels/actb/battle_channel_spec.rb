require "rails_helper"

RSpec.describe Actb::BattleChannel, type: :channel do
  before(:context) do
    Actb.setup
    Emox.setup
  end

  let_it_be(:user1) { User.create! }
  let_it_be(:user2) { User.create! }

  before do
    Actb::BaseChannel.redis.flushdb

    stub_connection current_user: user1
  end

  let_it_be(:current_room) do
    Actb::Room.create_with_members!([user1, user2])
  end

  let_it_be(:current_battle) do
    current_room.battle_create_with_members!
  end

  let_it_be(:question) do
    user1.actb_questions.create_mock1
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

  describe "#speak" do
    before do
      subscribe(battle_id: current_battle.id)
    end

    it do
      subscription.speak(message_body: "(message)")
      assert { user1.actb_room_messages.count == 1 }
    end
  end

  describe "#kotae_sentaku" do
    before do
      subscribe(battle_id: current_battle.id)
    end

    it do
      data = { membership_id: membership1.id, question_index: 0, question_id: question.id, ox_mark_key: "correct" }
      expect {
        subscription.kotae_sentaku(data)
      }.to have_broadcasted_to("actb/battle_channel/#{current_battle.id}").with(bc_action: "kotae_sentaku_broadcasted", bc_params: data)

      assert { question.ox_record.reload.o_count == 1 }
    end
  end

  describe "#next_trigger" do
    before do
      subscribe(battle_id: current_battle.id)
    end

    it do
      data = {
        membership_id: membership1.id,
        question_index: 1,
        question_id: question.id,
      }
      expect {
        subscription.next_trigger(data)
      }.to have_broadcasted_to("actb/battle_channel/#{current_battle.id}").with(bc_action: "next_trigger_broadcasted", bc_params: data)
    end
  end

  describe "#play_board_share" do
    before do
      subscribe(battle_id: current_battle.id)
    end

    it do
      data = {
        membership_id: membership1.id,
        share_sfen: "position startpos",
      }
      expect {
        subscription.play_board_share(data)
      }.to have_broadcasted_to("actb/battle_channel/#{current_battle.id}").with(bc_action: "play_board_share_broadcasted", bc_params: data)
    end
  end

  describe "#goal_hook" do
    before do
      subscribe(battle_id: current_battle.id)
    end

    it "結果画面へ" do
      expect {
        subscription.goal_hook({})
      }.to have_broadcasted_to("actb/battle_channel/#{current_battle.id}")
    end

    it "結果" do
      subscription.goal_hook({})
      current_battle.reload

      assert { current_battle.end_at    }
      assert { current_battle.final     }

      assert { membership1.judge.key == "win"  }
      assert { membership2.judge.key == "lose" }

      assert { user1.reload.rating == 1516 }
      assert { user2.reload.rating == 1484 }
    end
  end

  describe "#judgement_run" do
    before do
      subscribe(battle_id: current_battle.id)
    end

    let(:data) {
      {
        "member_infos_hash" => {
          membership1.id.to_s => {"ox_list" => ["correct"], "b_score" => 99},
          membership2.id.to_s => {"ox_list" => [],          "b_score" =>  0},
        }
      }
    }

    it "結果画面へ" do
      expect {
        subscription.judgement_run(data)
      }.to have_broadcasted_to("actb/battle_channel/#{current_battle.id}")
    end

    it "結果" do
      subscription.judgement_run(data)
      current_battle.reload

      assert { current_battle.end_at  }
      assert { current_battle.final   }

      assert { membership1.judge.key == "win"  }
      assert { membership2.judge.key == "lose" }

      assert { user1.reload.rating == 1516 }
      assert { user2.reload.rating == 1484 }

      assert { user1.actb_latest_xrecord.rating == 1516 }
      assert { user2.actb_latest_xrecord.rating == 1484 }

      assert { user1.actb_latest_xrecord.straight_win_count == 1 }
      assert { user1.actb_latest_xrecord.straight_lose_count == 0 }
      assert { user2.actb_latest_xrecord.straight_win_count == 0 }
      assert { user2.actb_latest_xrecord.straight_lose_count == 1 }
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> ..........
# >> 
# >> Finished in 1.36 seconds (files took 2.28 seconds to load)
# >> 10 examples, 0 failures
# >> 
