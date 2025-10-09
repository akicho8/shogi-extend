require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(name, message)
    find(".HandleNameModal input").set(name)         # 不正な名前を入力する
    find(".save_handle").click                       # 保存
    assert_text(message)                             # エラー出る
  end

  it "works" do
    window_a do
      visit_app
      global_menu_open
      menu_item_click("ハンドルネーム変更")
      case1("", "ハンドルネームを入力してください")
      case1("名無し", "ハンドルネームを入力してください")
      case1(".", "ハンドルネームを入力してください")
    end
  end

  it "URLから来ても不正なハンドルネームは通さない" do
    window_a do
      visit_app(room_key: :test_room, user_name: "nanashi", fixed_order_names: "nanashi", __visit_app_warning_skip__: true)
      assert_text("入退室")     # ハンドルネームが不正なのでダイアログが出ている
    end
  end
end
