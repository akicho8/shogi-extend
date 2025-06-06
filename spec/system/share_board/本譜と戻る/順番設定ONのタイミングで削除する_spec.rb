require "#{__dir__}/helper"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app(room_key: :test_room, user_name: "alice", fixed_order_state: "to_o1_state", autoexec: "honpu_main_setup")
    assert_honpu_open_on        # 本譜がある
    os_modal_open               # 順番設定を開いて
    os_switch_toggle            # 順番設定をONにする
    assert_honpu_open_off       # そのタイミングで本譜が消えている
  end
end
