require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a do
      find(".title_navbar_item").click       # タイトル変更モーダルを開く
      within(".modal-card") do
        find("input").set("(new_title)")     # 別のタイトルを入力
        find(".button.is-primary").click     # 更新ボタンを押す
      end
    end
    window_b do
      assert_text("(new_title)")             # b側のタイトルが変更されている
    end
  end
end
