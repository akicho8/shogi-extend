require "rails_helper"

RSpec.describe Actb::LobbyChannel, type: :channel do
  include ActbSupport

  before do
    Actb::BaseChannel.redis.flushdb

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
      expect { unsubscribe }.to have_broadcasted_to("actb/lobby_channel")
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
      expect { unsubscribe }.to have_broadcasted_to("actb/lobby_channel")
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
      expect { unsubscribe }.to have_broadcasted_to("actb/lobby_channel")
    end
  end

  describe "#matching_search" do
    # これは消してもいいかもしれない
    describe "同レートのマッチング" do
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
        expect { matching_search(user2) }.to have_broadcasted_to("actb/lobby_channel").exactly(2)
        # 1. matching_user_ids_hash を伝える(←これはなくてもよくね？)
        # 2. 作成した battle を伝える

        assert { Actb::Room.count == 1 }
      end
    end

    describe "レートを考慮したマッチング" do
      def user_of(rating)
        User.create!.tap do |e|
          e.actb_main_xrecord.update!(rating: rating)
        end
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

      let_it_be(:user1) { user_of(1500) }
      let_it_be(:user2) { user_of(1549) }
      let_it_be(:user3) { user_of(1550) }

      it "BはAとの差が50未満なのでいきなりマッチングする" do
        assert { start(user2) == [] }
      end

      it "BとCがマッチングしてAは残る" do
        assert { start(user3) == [user1, user3] }
        assert { start(user2) == [user1]         }
      end

      it "Cは1回目はダメだけど範囲を広げたのでマッチする" do
        assert { start(user3)     == [user1, user3] }
        assert { start(user3, 51) == []               }
      end
    end
  end

  def matching_search(user, params = {})
    user.actb_setting.update!(session_lock_token: SecureRandom.hex)
    subscription.matching_search(params.merge(session_lock_token: user.actb_setting.session_lock_token))
  end
end
