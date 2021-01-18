require "rails_helper"

RSpec.describe Wbook::SchoolChannel, type: :channel do
  include WbookSupportMethods

  before do
    Wbook::BaseChannel.redis.flushdb

    stub_connection current_user: user1
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
    it "正常接続" do
      subscribe
      assert { subscription.confirmed? }
    end

    it "オンラインリストに追加" do
      subscribe
      assert { Wbook::SchoolChannel.active_users == [user1] }
    end

    it "オンラインリスト通知" do
      expect { subscribe }.to have_broadcasted_to("wbook/school_channel").with(bc_action: "active_users_status_broadcasted", bc_params: { wbook_school_user_ids: [user1.id] })
    end
  end

  describe "#unsubscribe" do
    before do
      subscribe
    end

    it "オンラインリストから除外" do
      assert { Wbook::SchoolChannel.active_users == [user1] }
      unsubscribe
      assert { Wbook::SchoolChannel.active_users == [] }
    end

    it "オフラインリスト通知" do
      expect { unsubscribe }.to have_broadcasted_to("wbook/school_channel").with(bc_action: "active_users_status_broadcasted", bc_params: { wbook_school_user_ids: [] })
    end
  end
end
# >> Run options: exclude {:slow_spec=>true}
# >> .....
# >>
# >> Finished in 0.43664 seconds (files took 2.2 seconds to load)
# >> 5 examples, 0 failures
# >>
