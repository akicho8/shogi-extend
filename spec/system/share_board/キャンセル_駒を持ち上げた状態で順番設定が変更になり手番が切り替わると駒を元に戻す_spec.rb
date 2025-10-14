require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      visit_room(user_name: :alice, fixed_order: "alice,bob")
    end
    window_b do
      visit_room(user_name: :bob, fixed_order: "alice,bob")
    end
    window_a do
      place_click("77")          # alice は77の駒を持つ
      lifted_from("77")          # 77の駒を持っていることを保証する
    end
    window_b do
      os_modal_open              # 「順番設定」モーダルを開く(すでに有効になっている)
      find(".swap_handle").click # 先後入替
      os_submit_button_click               # 適用
      os_modal_close         # 閉じる
    end
    window_a do
      no_lifted_from("77")       # alice は77の駒を持っていたはずだが手番が変わったため駒を元に戻した
    end
  end
end
