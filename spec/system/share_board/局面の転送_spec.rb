require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    room_setup_by_user(user_name)
  end

  it "works" do
    window_a { case1(:alice) }
    window_b { case1(:bob)   }
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

      sidebar_open
      menu_item_click("局面の転送")                          # モーダルを開く
      find(:button, text: "転送する", exact_text: true).click # 反映する
    end
    window_b do
      assert_turn(1)                                          # bobの局面が戻っている
    end
  end
end
