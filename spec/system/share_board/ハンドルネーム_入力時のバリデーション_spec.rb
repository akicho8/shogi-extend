require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(name)
    find(".HandleNameModal input").set(name)         # 不正な名前を入力する
    find(".save_handle").click                       # 保存
    assert_text("ハンドルネームを入力してください")  # エラー出る
  end

  it "works" do
    visit_app(ng_word_check_p: true)
    global_menu_open
    menu_item_click("ハンドルネーム変更")

    case1("")
    case1(".")
    case1("名無し")
    case1("おちんちん")
  end
end
