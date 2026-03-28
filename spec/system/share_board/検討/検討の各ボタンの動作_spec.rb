require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "コピー" do
    visit_app
    sidebar_open
    find(".kifu_copy_handle_main").click
    assert_text "コピーしました"
  end

  # 次のようなテストは書けない
  # window = Capybara.window_opened_by { find(".piyo_shogi_open_handle").click }
  # switch_to_window(window)
  # assert_text "ぴよ将棋"

  it "ぴよ将棋" do
    visit_app
    sidebar_open
    assert_selector(".piyo_shogi_open_handle") { |e| e[:href].start_with?("piyoshogi://") }
  end

  it "KENTO" do
    visit_app
    sidebar_open
    window = Capybara.window_opened_by { find(".kento_open_handle").click }
    switch_to_window(window)
    Capybara.assert_title("KENTO", exact: true, wait: 5)
  end
end
