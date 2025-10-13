require "#{__dir__}/helper"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    window_a { visit_room(user_name: :alice) }
    window_b { visit_room(user_name: :bob)   }
    window_a do
      sidebar_open
      menu_item_click("局面編集")
      find(:button, "理解した上で編集する").click
      piece_move("77", "76")
      find(".button", text: "編集完了", exact_text: true).click
      assert_honpu_open_on
    end
    window_b do
      assert_honpu_open_on
    end
  end
end
