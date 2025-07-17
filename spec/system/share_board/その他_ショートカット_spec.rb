require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "編集モードでは発動しない" do
    visit_app(sp_mode: "edit")
    Capybara.current_session.active_element.send_keys("?") # 表示
    assert_no_selector(".SbShortcutModal")
  end

  it "ショートカットモーダル" do
    visit_app

    Capybara.current_session.active_element.send_keys("?") # 表示
    assert_selector(".SbShortcutModal")

    Capybara.current_session.active_element.send_keys("?") # 非表示
    assert_no_selector(".SbShortcutModal")
  end

  it "チャットを開いて閉じる" do
    visit_app

    Capybara.current_session.active_element.send_keys(:enter)
    assert_selector(".ChatModal")

    Capybara.current_session.active_element.send_keys(:enter)
    assert_no_selector(".ChatModal")
  end

  it "入退室" do
    visit_app
    Capybara.current_session.active_element.send_keys("1")
    assert_selector(".RoomSetupModal")
  end

  it "対局時計" do
    visit_app
    Capybara.current_session.active_element.send_keys("3")
    assert_selector(".ClockBoxModal")
  end

  it "棋譜コピー" do
    visit_app
    Capybara.current_session.active_element.send_keys("c")
    assert_text("コピーしました", wait: 3)
    assert { Clipboard.read.include?("棋戦：共有将棋盤") }
  end

  it "通常モード←→編集モード" do
    visit_app

    assert_selector(".SbApp.normal_mode_p")

    Capybara.current_session.active_element.send_keys([:shift, "e"])
    assert_selector(".SbApp.edit_mode_p")

    Capybara.current_session.active_element.send_keys([:shift, "e"])
    assert_selector(".SbApp.normal_mode_p")
  end

  # クリップボードの許可モーダルが出るためテストできない
  # it "棋譜の入力" do
  #   visit_app
  #   Clipboard.write("68S")
  #   Capybara.current_session.active_element.send_keys([:command, "v"])
  # end
end
