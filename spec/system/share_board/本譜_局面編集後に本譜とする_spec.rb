require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it do
    a_block { visit_app(room_key: :test_room, user_name: "alice") }
    b_block { visit_app(room_key: :test_room, user_name: "bob")   }
    a_block do
      hamburger_click
      menu_item_click("局面編集")
      find(:button, "理解した上で編集する").click
      piece_move("77", "76")
      find(".button", text: "編集完了", exact_text: true).click
      assert_honpu_link_exist
    end
    b_block do
      assert_honpu_link_exist
    end
  end
end
