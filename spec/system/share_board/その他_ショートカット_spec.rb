require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "ショートカットモーダル" do
    visit_app

    Capybara.current_session.active_element.send_keys("?") # 表示
    assert_selector(".SbShortcutModal")

    Capybara.current_session.active_element.send_keys("?") # 非表示
    assert_no_selector(".SbShortcutModal")
  end

  it "部屋に入る" do
    visit_app
    Capybara.current_session.active_element.send_keys("i")
    assert_selector(".RoomSetupModal")
  end

  it "対局時計" do
    visit_app
    Capybara.current_session.active_element.send_keys("t")
    assert_selector(".ClockBoxModal")
  end

  it "棋譜コピー" do
    visit_app
    Capybara.current_session.active_element.send_keys([:command, "c"])
    assert_text("コピーしました", wait: 3)
    assert2 { Clipboard.read.include?("棋戦：共有将棋盤") }
  end

  # クリップボードの許可モーダルが出るためテストできない
  # it "棋譜の読み込み" do
  #   visit_app
  #   Clipboard.write("68S")
  #   Capybara.current_session.active_element.send_keys([:command, "v"])
  # end
end
