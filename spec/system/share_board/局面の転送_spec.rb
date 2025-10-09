require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    window_a do
      room_setup_by_user(:alice)                          # aliceが部屋を作る
    end
    window_b do
      room_setup_by_user(:bob)                            # bobも同じ入退室
    end
    window_a do
      piece_move_o("77", "76", "☗7六歩")                      # 1手目
    end
    window_b do
      piece_move_o("33", "34", "☖3四歩")                      # 2手目
    end
    window_a do
      piece_move_o("27", "26", "☗2六歩")                      # 3手目
    end
    window_b do
      piece_move_o("83", "84", "☖8四歩")                      # 4手目
    end
    window_a do
      sp_controller_click("previous")                         # 3手戻す
      sp_controller_click("previous")
      sp_controller_click("previous")
      assert_turn(1)

      global_menu_open
      menu_item_click("局面の転送")                          # モーダルを開く
      find(:button, text: "転送する", exact_text: true).click # 反映する
    end
    window_b do
      assert_turn(1)                                          # bobの局面が戻っている
    end
  end
end
