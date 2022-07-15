require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "正しく同期する" do
    a_block do
      room_setup("my_room", "alice")                    # alice先輩が部屋を作る
    end
    b_block do
      room_setup("my_room", "bob")                      # bob後輩が同じ部屋に入る
    end
    a_block do
      piece_move_o("77", "76", "☗7六歩")                # aliceが指す
      assert_turn(1)                             # 1手進んでいる
    end
    b_block do
      assert_turn(1)                             # bob側も1手進んでいる
    end
    a_block do
      hamburger_click
      menu_item_click("初期配置に戻す")                 # 「初期配置に戻す」モーダルを開く
      find(".apply_button").click                       # 「N手目まで戻る」
      # buefy_dialog_button_click(".is-danger")           # 「本当に実行」クリック
      assert_turn(0)                             # 0手に戻っている
    end
    b_block do
      assert_turn(0)                             # bob側も0手に戻っている
    end
  end

  it "初期配置に戻すダイアログの中で局面を調整する" do
    a_block do
      room_setup("my_room", "alice")                    # alice先輩が部屋を作る
      piece_move_o("77", "76", "☗7六歩")                # aliceが指す
      assert_turn(1)                                    # 1手進んでいる
      hamburger_click
      menu_item_click("初期配置に戻す")                 # 「初期配置に戻す」モーダルを開く
      Capybara.within(".TurnChangeModal") do
        assert_text("局面 #0")                          # 初期配置に戻すため初期値は0手目になっているが
        find(".button.next").click                      # 「>」で
        assert_text("局面 #1")                          # 1手目に進める
      end
      find(".apply_button").click                       # 「N手目まで戻る」
      assert_turn(1)                                    # 0手目ではなく1手目に戻っている
    end
  end
end
