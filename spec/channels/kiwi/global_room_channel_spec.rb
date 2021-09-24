require "rails_helper"

module Kiwi
  RSpec.describe GlobalRoomChannel, type: :channel do
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
        # Kiwi::Lemon.everyone_broadcast
        # current_user.kiwi_my_lemons_singlecast
        # current_user.kiwi_done_lemon_singlecast
      end
    end
  end
end
