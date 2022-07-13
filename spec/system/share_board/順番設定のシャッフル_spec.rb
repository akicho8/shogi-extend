require "#{__dir__}/helper_methods"

RSpec.describe type: :system, share_board_spec: true do
  include HelperMethods

  it "works" do
    a_block do
      visit_app(room_code: :my_room, force_user_name: "1", ordered_member_names: "1,2,3,4", handle_name_validate_skip: "true")

      hamburger_click
      os_modal_handle                       # 「順番設定」モーダルを開く(すでに有効になっている)

      assert_order_setting_members ["1", "2", "3", "4"]

      order_toggle(1)                                   # 1 を観戦にする
      order_toggle(3)                                   # 3 を観戦にする

      find(".shuffle_handle").click
      assert_order_setting_members ["4", "2", "1", "3"] # 2 4 がメンバーでシャッフルされて 4 2 になり、残り 1 3 を追加

      find(".shuffle_handle").click
      assert_order_setting_members ["2", "4", "1", "3"] # 4 2 がメンバーでシャッフルされて 2 4 になり、残り 1 3 を追加
    end
  end
end
