require "rails_helper"

RSpec.describe Actb::LobbyChannel, type: :channel do
  let_it_be(:user) { User.create! }

  before do
    Actb::BaseChannel.redis.flushdb

    stub_connection current_user: user
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
      subscription.matching_search({})
    end

    it "対戦待ちリストから削除する" do
      assert { subscription.matching_users == [user] }
      unsubscribe
      assert { subscription.matching_users == [] }
    end

    it "対戦待ちリストを送信する" do
      expect { unsubscribe }.to have_broadcasted_to("actb/lobby_channel")
    end
  end

  describe "#unsubscribe" do
    before do
      subscribe
      subscription.matching_search({})
    end

    it "現在のユーザーをオンラインリストから削除する" do
      assert { subscription.matching_users == [user] }
      unsubscribe
      assert { subscription.matching_users == [] }
    end

    it "オフライン通知を送信する" do
      expect { unsubscribe }.to have_broadcasted_to("actb/lobby_channel")
    end
  end

  describe "#matching_cancel" do
    before do
      subscribe
      subscription.matching_search({})
    end

    it "現在のユーザーをオンラインリストから削除する" do
      assert { subscription.matching_users == [user] }
      subscription.matching_cancel({})
      assert { subscription.matching_users == [] }
    end

    it "オフライン通知を送信する" do
      expect { unsubscribe }.to have_broadcasted_to("actb/lobby_channel")
    end
  end

  describe "#matching_search" do
    # これは消してもいいかもしれない
    context "同レートのマッチング" do
      let_it_be(:user_a) { User.create! }
      let_it_be(:user_b) { User.create! }

      it "マッチング" do
        # user_a が対戦待ち
        stub_connection current_user: user_a
        subscribe
        subscription.matching_search({})
        assert { subscription.matching_users == [user_a] }

        # user_b が入ってきて対戦成立
        stub_connection current_user: user_b
        subscribe

        # (少くとも)2回ブロードキャスト
        expect { subscription.matching_search({}) }.to have_broadcasted_to("actb/lobby_channel").exactly(2)
        # 1. matching_user_ids_hash を伝える(←これはなくてもよくね？)
        # 2. 作成した battle を伝える

        assert { Actb::Room.count == 1 }
      end
    end

    context "レートを考慮したマッチング" do
      def user_of(rating)
        User.create!.tap do |e|
          e.actb_main_xrecord.update!(rating: rating)
        end
      end

      def start(user, matching_rate_threshold = nil)
        stub_connection current_user: user
        subscribe
        subscription.matching_search(matching_rate_threshold: matching_rate_threshold)
        subscription.matching_users
      end

      before do
        assert { start(user_a) == [user_a] }
      end

      let_it_be(:user_a) { user_of(1500) }
      let_it_be(:user_b) { user_of(1549) }
      let_it_be(:user_c) { user_of(1550) }

      it "BはAとの差が50未満なのでいきなりマッチングする" do
        assert { start(user_b) == [] }
      end

      it "BとCがマッチングしてAは残る" do
        assert { start(user_c) == [user_a, user_c] }
        assert { start(user_b) == [user_a]         }
      end

      it "Cは1回目はダメだけど範囲を広げたのでマッチする" do
        assert { start(user_c)     == [user_a, user_c] }
        assert { start(user_c, 51) == []               }
      end
    end
  end
end
