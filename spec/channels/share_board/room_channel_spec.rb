require "rails_helper"

RSpec.describe ShareBoard::RoomChannel, type: :channel do
  let(:user1)     { User.create!     }
  let(:room_code) { SecureRandom.hex }

  before do
    stub_connection(current_user: user1)
  end

  describe "接続" do
    it do
      subscribe(room_code: room_code)
      assert { subscription.confirmed? }
    end
  end

  describe "切断" do
    it do
      subscribe(room_code: room_code)
      assert { subscription.confirmed? }
      unsubscribe
    end
  end

  # front_app/components/ShareBoard/app_room.js の ac_room_perform に合わせる
  def data_factory(params = {})
    {
      "from_user_code" => SecureRandom.hex,
      "from_user_name" => "alice",
      "performed_at"   => Time.current.to_i,
      "active_level"   => 1,
      "API_VERSION"    => ShareBoardControllerMethods::API_VERSION, # サーバー側で生める
    }.merge(params)
  end

  describe "局面配布" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory("sfen" => "(sfen)", "turn_offset" => 0, message: "(message)")
      expect {
        subscription.force_sync(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "force_sync_broadcasted", bc_params: data)
    end
  end

  describe "指し手送信" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory({
          "sfen"              => "(sfen)",
          "turn_offset"       => 1,
          "last_location_key" => "white",
          "sequence_code"     => 1,
          "next_user_name"    => "bob",
          "lmi" => {
            "kif_without_from"    => "☗7六歩",
            "next_turn_offset"    => 1,
            "player_location_key" => "black",
            "yomiage"             => "ななろくふ",
          },
        })
      expect {
        subscription.sfen_share(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "sfen_share_broadcasted", bc_params: data)
    end
  end

  describe "指し手受信" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory("to_user_name" => "alice", "to_user_code" => SecureRandom.hex)
      expect {
        subscription.received_ok(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "received_ok_broadcasted", bc_params: data)
    end
  end

  describe "指手不達" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory("sfen_share_not_reach_count" => 1)
      expect {
        subscription.sfen_share_not_reach(data)
      }.to raise_error(StandardError, /指手不達.*1回目/)
    end
  end

  describe "タイトル共有" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory("title" => "(title)")
      expect {
        subscription.title_share(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "title_share_broadcasted", bc_params: data)
    end
  end

  describe "情報要求" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory
      expect {
        subscription.setup_info_request(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "setup_info_request_broadcasted", bc_params: data)
    end
  end

  describe "情報送信" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory
      expect {
        subscription.setup_info_send(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "setup_info_send_broadcasted", bc_params: data)
    end
  end

  describe "対局時計の共有" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory
      expect {
        subscription.clock_box_share(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "clock_box_share_broadcasted", bc_params: data)
    end
  end

  describe "生存通知" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory
      expect {
        subscription.member_info_share(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "member_info_share_broadcasted", bc_params: data)
    end
  end

  describe "順番機能" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory("order_func_p" => true)
      expect {
        subscription.order_func_share(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "order_func_share_broadcasted", bc_params: data)
    end
  end

  describe "順番設定" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory({
          "ordered_members" => [
            { "user_name" => "alice", },
            { "user_name" => "bob",   },
          ],
        })
      expect {
        subscription.ordered_members_share(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "ordered_members_share_broadcasted", bc_params: data)
    end
  end

  describe "メッセージ" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory("message" => "(message)")
      expect {
        subscription.message_share(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "message_share_broadcasted", bc_params: data)
    end
  end

  describe "ログ記録" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory("subject" => "(subject)", "body" => "body")
      subscription.ac_log(data)
    end
  end

  describe "エラー発動確認" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = data_factory("key_has_nil" => nil)
      expect {
        subscription.fake_error(data)
      }.to raise_error(ArgumentError)
    end
  end
end
