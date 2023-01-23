require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "正しく同期する" do
    a_block do
      room_setup("test_room", "alice")                    # alice先輩が部屋を作る
    end
    b_block do
      room_setup("test_room", "bob")                      # bob後輩が同じ部屋に入る
    end
    a_block do
      piece_move_o("77", "76", "☗7六歩")                # aliceが指す
    end
    b_block do
      piece_move_o("33", "34", "☖3四歩")                # bobが指す
    end
    a_block do
      hamburger_click
      menu_item_click("1手戻す (待った)")                 # 「1手戻す」モーダルを開く
      find(".apply_button").click                       # 「N手目まで戻る」
      # buefy_dialog_button_click(".is-danger")           # 「本当に実行」クリック
      assert_turn(1)                             # 1手目に戻っている
    end
    b_block do
      assert_turn(1)                             # bob側も1手に戻っている
    end
  end
end
