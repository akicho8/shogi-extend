require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    piece_move("77", "76")
    sidebar_open
    window = Capybara.window_opened_by do
      find(".kifu_print_handle").click
    end
    switch_to_window(window)
    assert_text "記録係"
    assert_text "７六歩"
    assert_selector ".back_handle" # 戻るボタンがある
  end
end
