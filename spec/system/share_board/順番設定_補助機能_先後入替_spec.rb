require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      visit_app(room_code: :my_room, fixed_user_name: "1", fixed_order_names: "1,2,3,4", handle_name_validate: "false")

      hamburger_click
      os_modal_handle                       # 「順番設定」モーダルを開く(すでに有効になっている)

      assert_order_setting_members ["1", "2", "3", "4"]

      find(".swap_handle").click                        # 先後入替
      assert_text("1さんが先後を入れ替えました", wait: 60)
      assert_order_setting_members ["2", "1", "4", "3"] # 2つづつswapしていく
    end
  end
end
