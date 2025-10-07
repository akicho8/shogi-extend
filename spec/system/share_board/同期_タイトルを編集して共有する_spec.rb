require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      room_setup("test_room", "alice")         # alceが部屋を作る
    end
    b_block do
      room_setup("test_room", "bob")           # bobもaliceと同じ合言葉で部屋を作る
    end
    a_block do
      find(".title_navbar_item").click       # タイトル変更モーダルを開く
      within(".modal-card") do
        find("input").set("(new_title)")     # 別のタイトルを入力
        find(".button.is-primary").click     # 更新ボタンを押す
      end
    end
    b_block do
      assert_text("(new_title)")             # bob側のタイトルが変更されている
    end
  end
end
