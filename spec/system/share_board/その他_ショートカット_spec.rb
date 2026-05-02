require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "編集モードでは発動しない" do
    visit_app(sp_mode: "edit")
    shortcut_send("?") # 表示
    assert_no_selector(".SbShortcutModal")
  end

  it "ショートカットモーダル" do
    visit_app

    shortcut_send("?") # 表示
    assert_selector(".SbShortcutModal")

    shortcut_send("?") # 非表示
    assert_no_selector(".SbShortcutModal")
  end

  it "チャットを開いて閉じる" do
    visit_app

    shortcut_send(:enter)
    assert_selector(".ChatModal")

    shortcut_send(:enter)
    assert_no_selector(".ChatModal")
  end

  it "入退室" do
    visit_app
    shortcut_send("e")
    assert_selector(".GateModal")
  end

  it "時計" do
    visit_room(user_name: :a)
    shortcut_send("t")
    assert_selector(".ClockBoxModal")
  end

  it "棋譜コピー" do
    visit_app
    shortcut_send("c")
    assert_text("コピーしました", wait: 3)
    assert { Clipboard.read.include?("棋戦：共有将棋盤") }
  end

  it "通常モード←→編集モード" do
    visit_app

    assert_selector(".SbApp.play_mode_p")

    shortcut_send("E")
    assert_selector(".SbApp.edit_mode_p")

    shortcut_send("E")
    assert_selector(".SbApp.play_mode_p")
  end

  # クリップボードの許可モーダルが出るためテストできない
  xit "棋譜の読み込み" do
    visit_app
    Clipboard.write("68S")
    shortcut_send("V")
  end
end
