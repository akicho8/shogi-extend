require "rails_helper"

RSpec.describe Acns3::SchoolChannel, type: :channel do
  let(:user) { Colosseum::User.create! }

  before do
    Acns3::SchoolChannel.redis.flushdb

    stub_connection current_user: user
  end

  # describe "接続失敗" do
  #   it do
  #     stub_connection current_user: nil
  #     subscribe
  #     p subscription.confirmed?
  #     p subscription.rejected?
  #   end
  # end

  describe "#subscribe" do
    subject do
      subscribe
      subscription
    end

    it "正常接続" do
      assert { subject.confirmed? }
    end

    it "オンラインリストに追加" do
      assert { subject.online_users == [user] }
    end

    it "オンラインリスト通知" do
      expect { subject }.to have_broadcasted_to("acns3/school_channel").with({
          online_user_ids: [user.id],
          room_user_ids: [],
        })
    end
  end

  describe "#unsubscribe" do
    before do
      subscribe
    end

    it "オンラインリストから除外" do
      assert { subscription.online_users == [user] }
      unsubscribe
      assert { subscription.online_users == [] }
    end

    it "オフラインリスト通知" do
      expect { unsubscribe }.to have_broadcasted_to("acns3/school_channel").with({
          online_user_ids: [],
          room_user_ids: [],
        })
    end
  end
end
