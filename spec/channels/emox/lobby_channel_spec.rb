require "rails_helper"

RSpec.describe Emox::LobbyChannel, type: :channel do
  include EmoxSupportMethods

  before do
    Emox::BaseChannel.redis.flushdb

    stub_connection current_user: user1
  end

  describe "#subscribe" do
    before do
      subscribe
    end

    it "subscribedが通った(?)" do
      assert { subscription.confirmed? }
    end
  end

  describe "#unsubscribe" do
    before do
      subscribe
      matching_search(user1)
    end

    it "対戦待ちリストから削除する" do
      assert { subscription.matching_users == [user1] }
      unsubscribe
      assert { subscription.matching_users == [] }
    end

    it "対戦待ちリストを送信する" do
      expect { unsubscribe }.to have_broadcasted_to("emox/lobby_channel")
    end
  end

  describe "#unsubscribe" do
    before do
      subscribe
      matching_search(user1)
    end

    it "現在のユーザーをオンラインリストから削除する" do
      assert { subscription.matching_users == [user1] }
      unsubscribe
      assert { subscription.matching_users == [] }
    end

    it "オフライン通知を送信する" do
      expect { unsubscribe }.to have_broadcasted_to("emox/lobby_channel")
    end
  end

  describe "#matching_cancel" do
    before do
      subscribe
      matching_search(user1)
    end

    it "現在のユーザーをオンラインリストから削除する" do
      assert { subscription.matching_users == [user1] }
      subscription.matching_cancel({})
      assert { subscription.matching_users == [] }
    end

    it "オフライン通知を送信する" do
      expect { unsubscribe }.to have_broadcasted_to("emox/lobby_channel")
    end
  end

  describe "#matching_search" do
    # これは消してもいいかもしれない
    context "同レートのマッチング" do
      it "マッチング" do
        # user1 が対戦待ち
        stub_connection current_user: user1
        subscribe
        matching_search(user1)
        assert { subscription.matching_users == [user1] }

        # user2 が入ってきて対戦成立
        stub_connection current_user: user2
        subscribe

        # (少くとも)2回ブロードキャスト
        expect { matching_search(user2) }.to have_broadcasted_to("emox/lobby_channel").exactly(2)
        # 1. matching_user_ids_hash を伝える(←これはなくてもよくね？)
        # 2. 作成した battle を伝える

        assert { Emox::Room.count == 1 }
      end
    end

    context "レートを考慮したマッチング" do
      def user_of
        User.create!
      end

      def start(user, matching_rate_threshold = nil)
        stub_connection current_user: user
        subscribe
        matching_search(user, matching_rate_threshold: matching_rate_threshold)
        subscription.matching_users
      end

      before do
        assert { start(user1) == [user1] }
      end

      let_it_be(:user1) { user_of }
      let_it_be(:user2) { user_of }
      let_it_be(:user3) { user_of }

      it "レートとか関係なくすぐマッチングする" do
        assert { start(user2) == [] }
      end
    end
  end

  def matching_search(user, params = {})
    user.emox_setting.update!(session_lock_token: SecureRandom.hex)
    subscription.matching_search(params.merge(session_lock_token: user.emox_setting.session_lock_token))
  end
end
