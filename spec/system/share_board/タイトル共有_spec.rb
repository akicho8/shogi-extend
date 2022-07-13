require "#{__dir__}/helper_methods"

RSpec.describe type: :system, share_board_spec: true do
  include HelperMethods

  it "works" do
    a_block do
      room_setup("my_room", "alice")         # alceが部屋を作る
    end
    b_block do
      room_setup("my_room", "bob")           # bobもaliceと同じ合言葉で部屋を作る
    end
    a_block do
      find(".title_edit_navbar_item").click  # タイトル変更モーダルを開く
      within(".modal-card") do
        find("input").set("(new_title)")     # 別のタイトルを入力
        find(".button.is-primary").click     # 更新ボタンを押す
      end
    end
    b_block do
      assert_text("(new_title)")             # bob側のタイトルが変更されている
      within(".ShareBoardActionLog") do
        assert_text("タイトル変更", wait: 9) # 履歴にも追加された
      end
    end
  end
end
