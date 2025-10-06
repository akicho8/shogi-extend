require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      visit_app2(room_key: :test_room, user_name: "alice", fixed_order_names: "alice,bob")
    end
    b_block do
      visit_app2(room_key: :test_room, user_name: "bob", fixed_order_names: "alice,bob")
    end
    a_block do
      place_click("77")          # alice は77の駒を持つ
      lifted_from("77")          # 77の駒を持っていることを保証する
    end
    b_block do
      os_modal_open              # 「順番設定」モーダルを開く(すでに有効になっている)
      find(".swap_handle").click # 先後入替
      os_submit_button_click               # 適用
      os_modal_close         # 閉じる
    end
    a_block do
      no_lifted_from("77")       # alice は77の駒を持っていたはずだが手番が変わったため駒を元に戻した
    end
  end
end
