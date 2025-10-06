require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "部屋を立てていない場合は普通に局面編集に入れる" do
    visit_app
    global_menu_open
    menu_item_click("局面編集")
    piece_move("77", "76")
    find(".button", text: "編集完了", exact_text: true)
  end

  it "部屋を立てている場合は「理解した上で編集する」の警告ダイアログが出る" do
    a_block { visit_room(room_key: :test_room, user_name: "alice") }
    b_block { visit_room(room_key: :test_room, user_name: "bob")   }
    a_block do
      global_menu_open
      menu_item_click("局面編集")
      find(:button, "理解した上で編集する").click
      piece_move("77", "76")
      find(".button", text: "編集完了", exact_text: true).click
    end
  end
end
