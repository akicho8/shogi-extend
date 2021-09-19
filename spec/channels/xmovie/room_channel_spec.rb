require "rails_helper"

module Xmovie
  RSpec.describe RoomChannel, type: :channel do
    let(:user1) { User.create! }

    before do
      stub_connection(current_user: user1)
    end

    describe "接続" do
      it do
        subscribe
        assert { subscription.confirmed? }
      end
    end

    describe "切断" do
      it do
        subscribe
        assert { subscription.confirmed? }
        unsubscribe
      end
    end

    def data_factory(params)
      {
      }.merge(params)
    end

    describe "接続後に1回だけ呼ぶ" do
      before do
        subscribe
      end
      it do
        data = data_factory({})
        subscription.setup_request(data)
        # 次の3つが呼ばれるけどテストの書き方わからん
        # XmovieRecord.everyone_broadcast
        # current_user.my_records_singlecast
        # current_user.done_record_singlecast
      end
    end
  end
end
