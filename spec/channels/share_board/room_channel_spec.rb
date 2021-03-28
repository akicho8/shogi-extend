require "rails_helper"

RSpec.describe ShareBoard::RoomChannel, type: :channel do
  let(:user1)     { User.create!     }
  let(:room_code) { SecureRandom.hex }

  before do
    stub_connection current_user: user1
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

  describe "盤の共有" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = { user_code: SecureRandom.hex, sfen: "(sfen)", title: "(title)" }
      expect {
        subscription.sfen_share(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "sfen_share_broadcasted", bc_params: data)
    end
  end

  describe "タイトル共有" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = { user_code: SecureRandom.hex, title: "(title)" }
      expect {
        subscription.title_share(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "title_share_broadcasted", bc_params: data)
    end
  end

  describe "盤の情報を要求" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = { user_code: SecureRandom.hex }
      expect {
        subscription.board_info_request(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "board_info_request_broadcasted", bc_params: data)
    end
  end

  describe "盤の情報の要求に答える" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = { user_code: SecureRandom.hex }
      expect {
        subscription.board_info_send(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "board_info_send_broadcasted", bc_params: data)
    end
  end

  describe "対局時計の共有" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = { user_code: SecureRandom.hex }
      expect {
        subscription.chess_clock_share(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "chess_clock_share_broadcasted", bc_params: data)
    end
  end

  describe "参加者の共有" do
    before do
      subscribe(room_code: room_code)
    end
    it do
      data = { user_code: SecureRandom.hex }
      expect {
        subscription.member_info_share(data)
      }.to have_broadcasted_to("share_board/room_channel/#{room_code}").with(bc_action: "member_info_share_broadcasted", bc_params: data)
    end
  end
end
