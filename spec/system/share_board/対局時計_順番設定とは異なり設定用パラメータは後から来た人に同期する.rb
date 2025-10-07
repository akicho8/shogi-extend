require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      visit_room(room_key: :test_room, user_name: "alice")
      clock_open                       # 対局時計を開いて ON にする
      clock_box_form_set(:black, 1, 2, 3, 4)        # フォームで入力した状態
    end
    b_block do
      visit_room(room_key: :test_room, user_name: "bob")
      global_menu_open                  # サイドメニューを開く
      cc_modal_open_handle                  # 「対局時計」を開く
      clock_box_form_eq(:black, 1, 2, 3, 4) # alice が操作中の設定が届いている
    end
  end
end
