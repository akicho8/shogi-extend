require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(name)
    find(".HandleNameModal input").set(name)         # 不正な名前を入力する
    find(".save_handle").click                       # 保存
    assert_text("ハンドルネームを入力しよう")  # エラー出る
  end

  it "works" do
    visit_app(ng_word_check_p: true)
    sidebar_open
    menu_item_click("ハンドルネーム変更")

    case1("")
    case1(".")
    case1("名無し")
    case1("おちんちん")
  end
end
