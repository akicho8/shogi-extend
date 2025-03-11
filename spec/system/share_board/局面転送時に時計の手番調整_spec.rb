require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  before do
    @INITIAL_SEC = 30
  end

  it "works" do
    a_block do
      room_setup("test_room", "alice")                 # aliceが部屋を作る
    end
    b_block do
      room_setup("test_room", "bob")                   # bobが部屋を作る
    end
    a_block do
      clock_open
      clock_box_form_set(:black, 0, @INITIAL_SEC, 0, 0)   # 秒読みだけを設定
      find(:button, :class => "play_button").click   # 開始
      find(:button, :text => "無視して開始する", exact_text: true).click
      modal_close_handle                             # 閉じる (ヘッダーに置いている)
    end
    a_block do
      piece_move_o("77", "76", "☗7六歩")             # 初手を指す
    end
    b_block do
      assert_clock_active_white                      # 時計は後手
      assert_turn(1)                                 # 手数1
      sleep(1)                                       # bobは1秒考えていた
    end
    a_block do
      turn_minus_one
      assert_turn(0)                                 # 0手目に戻せてる

      global_menu_open
      menu_item_click("局面の転送")                 # モーダルを開く
      find(:button, text: "転送する", exact_text: true).click   # 反映する

      assert_clock_active_black                      # 時計は先手に切り替わっている
    end
    b_block do
      assert_clock_active_black                      # bob側も時計が先手になっている
      assert_white_read_sec(@INITIAL_SEC)            # 秒読みも復活している
    end
  end
end
