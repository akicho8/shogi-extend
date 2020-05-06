require "rails_helper"

RSpec.describe Acns3::LobbyChannel, type: :channel do
  let(:user) { Colosseum::User.create! }

  before do
    Acns3::SchoolChannel.redis.flushdb

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
      subscription.matching_start({})
    end

    it "対戦待ちリストから削除する" do
      assert { subscription.matching_users == [user] }
      unsubscribe
      assert { subscription.matching_users == [] }
    end

    it "対戦待ちリストを送信する" do
      expect { unsubscribe }.to have_broadcasted_to("acns3/lobby_channel").with(matching_list: [])
    end
  end

  describe "#unsubscribe" do
    before do
      subscribe
      subscription.matching_start({})
    end

    it "現在のユーザーをオンラインリストから削除する" do
      assert { subscription.matching_users == [user] }
      unsubscribe
      assert { subscription.matching_users == [] }
    end

    it "オフライン通知を送信する" do
      expect { unsubscribe }.to have_broadcasted_to("acns3/lobby_channel").with(matching_list: [])
    end
  end

  describe "#matching_cancel" do
    before do
      subscribe
      subscription.matching_start({})
    end

    it "現在のユーザーをオンラインリストから削除する" do
      assert { subscription.matching_users == [user] }
      subscription.matching_cancel({})
      assert { subscription.matching_users == [] }
    end

    it "オフライン通知を送信する" do
      expect { unsubscribe }.to have_broadcasted_to("acns3/lobby_channel").with(matching_list: [])
    end
  end

  describe "#matching_start" do
    # これは消してもいいかもしれない
    context "同レートのマッチング" do
      let(:user_a) { Colosseum::User.create! }
      let(:user_b) { Colosseum::User.create! }

      it "マッチング" do
        # user_a が対戦待ち
        stub_connection current_user: user_a
        subscribe
        subscription.matching_start({})
        assert { subscription.matching_users == [user_a] }

        # user_b が入ってきて対戦成立
        stub_connection current_user: user_b
        subscribe

        # (少くとも)2回ブロードキャスト
        expect { subscription.matching_start({}) }.to have_broadcasted_to("acns3/lobby_channel").twice
        # 1. matching_list を伝える(←これはなくてもよくね？)
        # 2. 作成した room を伝える

        assert { Acns3::Room.count == 1 }
      end
    end

    context "レートを考慮したマッチング" do
      def user_of(rating)
        Colosseum::User.create!.tap do |e|
          e.acns3_profile.update!(rating: rating)
        end
      end

      def start(user, matching_rate_threshold = nil)
        stub_connection current_user: user
        subscribe
        subscription.matching_start(matching_rate_threshold: matching_rate_threshold)
        subscription.matching_users
      end

      before do
        assert { start(user_a) == [user_a]         }
      end

      let(:user_a) { user_of(1500) }
      let(:user_b) { user_of(1549) }
      let(:user_c) { user_of(1550) }

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
