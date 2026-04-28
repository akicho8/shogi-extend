require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app
    piece_move_o("77", "76", "☗7六歩")
    piece_move_o("33", "34", "☖3四歩")
    assert_turn(2)
    shortcut_send("W")
    assert_honpu_open_on
    find(".honpu_modal_open_handle").click         # 「本譜」ボタンを押す
    Capybara.within(".TimeMachineModal") do
      assert_selector(".master_turn", text: "#2", exact_text: true) # 当然2手目になっている
      find(".button.previous").click                  # 「<」で1手目に進めると
      assert_selector(".master_turn", text: "#1", exact_text: true) # 1手目になっている
    end
    find(".time_machine_modal_apply_handle").click    # 「N手目まで戻る」
    assert_turn(1)                                    # 1手目に変更されている
  end
end
