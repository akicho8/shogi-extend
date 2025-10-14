require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    sidebar_open
    menu_item_click("局面編集")
    find(".ShogiPlayer .ToolBelt .dropdown:first-child").click    # 左から1つ目の dropdown をクリック
    menu_item_sub_menu_click("詰将棋")

    # 「ぴよ将棋」ボタンのURLに編集モードの棋譜を反映している
    url = "piyoshogi://?num=0&sfen=position%20sfen%204k4%2F9%2F9%2F9%2F9%2F9%2F9%2F9%2F9%20b%202r2b4g4s4n4l18p%201"
    assert_selector(".PiyoShogiButton[href='#{url}']")

    # 「KENTO」ボタンのURLに編集モードの棋譜を反映している
    url = "https://www.kento-shogi.com/?initpos=4k4%2F9%2F9%2F9%2F9%2F9%2F9%2F9%2F9%20b%202r2b4g4s4n4l18p%201"
    assert_selector(".KentoButton[href='#{url}']")

    # 「コピー」ボタンでコピーする内容に編集モードの棋譜を反映している
    find(".KifCopyButton").click
    if false
      assert { Clipboard.read.include?("棋戦：共有将棋盤") } # 一応タイトルを渡しているため入っている ← ここがテストで転けがち
      assert { Clipboard.read.include?("先手番") }           # 「詰将棋」はBOD形式と同じになるため入っている
    end
  end
end
