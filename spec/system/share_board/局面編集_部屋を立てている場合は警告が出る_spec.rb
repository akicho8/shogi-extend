require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "部屋を立てていない場合は普通に局面編集に入れる" do
    visit_app
    sidebar_open
    menu_item_click("局面編集")
    piece_move("77", "76")
    find(".button", text: "編集完了", exact_text: true)
  end

  it "部屋を立てている場合は「理解した上で編集する」の警告ダイアログが出る" do
    window_a { visit_room(user_name: :a) }
    window_b { visit_room(user_name: :b)   }
    window_a do
      sidebar_open
      menu_item_click("局面編集")
      find(:button, "理解した上で編集する").click
      piece_move("77", "76")
      find(".button", text: "編集完了", exact_text: true).click
    end
  end
end
