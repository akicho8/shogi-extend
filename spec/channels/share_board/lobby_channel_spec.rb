require "rails_helper"

RSpec.describe ShareBoard::LobbyChannel, type: :channel do
  let(:user1) { User.create! }

  before do
    stub_connection(current_user: user1)
  end

  describe "接続" do
    it "works" do
      subscribe
      assert { subscription.confirmed? }
    end
  end

  describe "切断" do
    it "works" do
      subscribe
      assert { subscription.confirmed? }
      unsubscribe
    end
  end

  # nuxt_side/components/ShareBoard/auto_matching/app_xmatch.js と合わせる
  def data_factory(params = {})
    {
      "from_connection_id" => SecureRandom.hex,
      "from_user_name"     => "alice",
      "performed_at"       => (Time.current.to_f * 1000).to_i,
      "xmatch_redis_ttl"   => 60 * 3,
      "API_VERSION"        => AppConfig[:share_board_api_version], # サーバー側で生める
    }.merge(params)
  end

  describe "ルール選択ON" do
    before do
      subscribe
    end
    it "works" do
      data = data_factory("xmatch_rule_key" => "rule_1vs1_05_00_00_5_pRvsB")
      expect {
        subscription.rule_select(data)
      }.to have_broadcasted_to("share_board/lobby_channel")
    end
  end

  describe "ルール選択OFF" do
    before do
      subscribe
    end
    it "works" do
      data = data_factory
      expect {
        subscription.rule_unselect(data)
      }.to have_broadcasted_to("share_board/lobby_channel")
    end
  end
end
