require "rails_helper"

# https://techracho.bpsinc.jp/hachi8833/2018_05_16/55546
RSpec.describe Acns3::SchoolChannel, type: :channel do
  let_it_be(:user) { Colosseum::User.create! }

  before do
    Acns3::SchoolChannel.redis.flushdb

    # 渡された引数で app/channels/application_cable/connection.rb を初期化する
    stub_connection current_user: user
  end

  describe "#subscribe" do
    subject do
      subscribe    # subscribed を実行する
      subscription # インスタンス
    end

    it "subscribedが通った(?)" do
      expect(subject).to be_confirmed
      # expect(subject).to have_stream_for(project)
    end

    it "現在のユーザーをオンラインリストに登録する" do
      assert { subject.online_user_ids == [user.id.to_s] }
    end

    it "オンライン通知を送信する" do
      expect { subject }.to have_broadcasted_to("acns3/school_channel").with({
          online_user_ids: [user.id.to_s],
          room_user_ids: [],
        })
    end
  end

  describe "#unsubscribe" do
    before do
      # unsbscribeを呼ぶ前に最初にsubscribeしなければならない
      subscribe
    end

    it "現在のユーザーをオンラインリストから削除する" do
      assert { subscription.online_user_ids == [user.id.to_s] }
      unsubscribe
      assert { subscription.online_user_ids == [] }
    end

    it "オフライン通知を送信する" do
      expect { unsubscribe }.to have_broadcasted_to("acns3/school_channel").with({
          online_user_ids: [],
          room_user_ids: [],
        })
    end
  end
end
