require "rails_helper"

RSpec.describe ShareBoard::RoomChannel, type: :channel, share_board_spec: true do
  let(:user1)       { User.create!                            }
  let(:room_key)   { SecureRandom.hex                        }
  let(:channel_key) { "share_board/room_channel/#{room_key}" }

  before do
    ShareBoard.setup
    stub_connection(current_user: user1, once_uuid: "(uuid)")
  end

  describe "接続" do
    it "works" do
      subscribe(room_key: room_key)
      assert { subscription.confirmed? }
    end
  end

  describe "切断" do
    it "works" do
      subscribe(room_key: room_key)
      assert { subscription.confirmed? }
      unsubscribe
    end
  end

  # nuxt_side/components/ShareBoard/app_room.js の ac_room_perform に合わせる
  def data_factory(params = {})
    {
      "from_connection_id" => SecureRandom.hex,
      "from_user_name" => "alice",
      "performed_at"   => (Time.current.to_f * 1000).to_i,
      "ac_events_hash" => {},
      "API_VERSION"    => AppConfig[:share_board_api_version], # サーバー側で生める
      "debug_mode_p"   => true,
    }.merge(params)
  end

  describe "部屋退出" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory
      expect {
        subscription.room_leave(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "room_leave_broadcasted", bc_params: data)
    end
  end

  describe "局面配布" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("sfen" => "(sfen)", "turn" => 0, message: "(message)")
      expect {
        subscription.force_sync(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "force_sync_broadcasted", bc_params: data)
    end
  end

  describe "本譜配布" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("sfen" => "(sfen)", "turn" => 0)
      expect {
        subscription.honpu_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "honpu_share_broadcasted", bc_params: data)
    end
  end

  describe "指し手送信" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory({
          "sfen"              => "(sfen)",
          "turn_offset"       => 1,
          # "last_location_key" => "white",
          "rs_seq_id"     => 1,
          "next_user_name"    => "bob",
          "elapsed_sec"       => 1,
          "illegal_names"     => ["二歩", "千日手"],
          "lmi" => {
            "kif_without_from"    => "☗7六歩",
            "next_turn_offset"    => 1,
            "player_location_key" => "black",
            "yomiage"             => "ななろくふ",
          },
        })
      expect {
        subscription.sfen_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "sfen_share_broadcasted", bc_params: data)
    end
  end

  describe "指し手受信" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("to_user_name" => "alice", "to_connection_id" => SecureRandom.hex)
      expect {
        subscription.rs_receive_success(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "rs_receive_success_broadcasted", bc_params: data)
    end
  end

  describe "指手不達" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("rs_failed_count" => 1)
      subscription.rs_failed_notify(data)
      assert { AppLog.last.subject.include?("指手不達") }
    end
  end

  describe "タイトル共有" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("title" => "(title)")
      expect {
        subscription.title_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "title_share_broadcasted", bc_params: data)
    end
  end

  describe "情報要求" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory
      expect {
        subscription.setup_info_request(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "setup_info_request_broadcasted", bc_params: data)
    end
  end

  describe "情報送信" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory
      expect {
        subscription.setup_info_send(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "setup_info_send_broadcasted", bc_params: data)
    end
  end

  describe "対局時計の共有" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory({
          "cc_behavior_key" => "cc_behavior_start",
          "cc_params" => [
            { "initial_main_min"  => 0, "initial_read_sec"  => 1, "initial_extra_min" => 2, "every_plus" => 3 },
            { "initial_main_min"  => 0, "initial_read_sec"  => 1, "initial_extra_min" => 2, "every_plus" => 3 },
          ],
          "current_url" => SecureRandom.hex,
        })
      expect {
        subscription.clock_box_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "clock_box_share_broadcasted", bc_params: data)
    end
  end

  describe "生存通知" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory
      expect {
        subscription.member_info_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "member_info_share_broadcasted", bc_params: data)
    end
  end

  describe "順番機能" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("order_enable_p" => true)
      expect {
        subscription.order_switch_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "order_switch_share_broadcasted", bc_params: data)
    end
  end

  describe "順番設定" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory({
          "order_unit" => [
            # FIXME
            { "user_name" => "alice", },
            { "user_name" => "bob",   },
          ],
        })
      expect {
        subscription.new_order_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "new_order_share_broadcasted", bc_params: data)
    end
  end

  describe "思考印" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory({})
      expect {
        subscription.think_mark_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "think_mark_share_broadcasted", bc_params: data)
    end
  end

  describe "メッセージ" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("content" => "(content)", "message_scope_key" => "ms_private")
      expect {
        subscription.message_share(data)
      }.to have_broadcasted_to(channel_key)
    end
  end

  describe "ChatGPTに発言を促す" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("content" => "", "message_scope_key" => "ms_public")
      subscription.ai_something_say(data)
    end
  end

  describe "投了発動" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory
      expect {
        subscription.give_up_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "give_up_share_broadcasted", bc_params: data)
    end
  end

  describe "PING" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory
      expect {
        subscription.ping_command(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "ping_command_broadcasted", bc_params: data)
    end
  end

  describe "PONG" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory
      expect {
        subscription.pong_command(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "pong_command_broadcasted", bc_params: data)
    end
  end

  describe "ログ記録" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("subject" => "(subject)", "body" => "body")
      subscription.ac_log(data)
    end
  end

  describe "エラー発動確認" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("key_has_nil" => nil)
      expect {
        subscription.fake_error(data)
      }.to raise_error(ArgumentError)
    end
  end

  describe "共有アクションログ" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("label" => "(label)", message: "(message)")
      expect {
        subscription.al_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "al_share_broadcasted", bc_params: data)
    end
  end

  describe "xprofile_load" do
    before do
      ShareBoard::Room.mock(room_key: room_key)
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("reqeust_user_name" => "alice")
      expect {
        subscription.xprofile_load(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "xprofile_load_broadcasted", bc_params: data.merge("users_match_record" => {"alice" => {win_count: 1, lose_count: 0}}))
    end
  end

  describe "xprofile_share" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("users_match_record" => { "alice" => { win_count: 0, lose_count: 0 } })
      expect {
        subscription.xprofile_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "xprofile_share_broadcasted", bc_params: data)
    end
  end

  describe "強制退室" do
    before do
      subscribe(room_key: room_key)
    end
    it "works" do
      data = data_factory("kicked_user_name" => "(kicked_user_name)")
      expect {
        subscription.user_kick(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "user_kick_broadcasted", bc_params: data)
    end
  end

  describe "お題" do
    before do
      subscribe(room_key: room_key)
    end
    it "配送" do
      data = data_factory("odai" => "xxx")
      expect {
        subscription.odai_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "odai_share_broadcasted", bc_params: data)
    end
    it "削除" do
      data = data_factory
      expect {
        subscription.odai_delete(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "odai_delete_broadcasted", bc_params: data)
    end
    it "投票" do
      data = data_factory("voted_latest_index" => 0)
      expect {
        subscription.vote_select_share(data)
      }.to have_broadcasted_to(channel_key).with(bc_action: "vote_select_share_broadcasted", bc_params: data)
    end
  end
end
