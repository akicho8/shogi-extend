require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    # 入室
    room_setup_by_user(:a)

    # 退室
    sidebar_open
    gate_modal_open_handle
    find(".GateModal .gate_leave_handle").click

    # 再入室
    find(".GateModal .new_room_key input").set("", clear: :backspace)                                # 合言葉を消す
    assert_selector(".autocomplete .dropdown-item:first-child", text: "test_room", exact_text: true) # 前回の入力が補完の候補に出ている
    find(".autocomplete .dropdown-item:first-child").click                                           # それをクリックする
    within(".GateModal .new_room_key") { assert_selector(:fillable_field, with: "test_room") }       # 合言葉として入力される
  end
end
