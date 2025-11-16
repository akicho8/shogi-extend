require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      visit_room(user_name: :a)
      clock_open                       # 対局時計を開いて ON にする
      clock_box_form_set(:black, 1, 2, 3, 4)        # フォームで入力した状態
    end
    window_b do
      visit_room(user_name: :b)
      sidebar_open                  # サイドメニューを開く
      cc_modal_open_handle                  # 「対局時計」を開く
      clock_box_form_eq(:black, 1, 2, 3, 4) # a が操作中の設定が届いている
    end
  end
end
