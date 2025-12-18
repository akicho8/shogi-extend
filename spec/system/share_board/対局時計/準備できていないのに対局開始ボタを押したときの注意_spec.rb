require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "順番設定をせずに対局開始ボタンを押した場合" do
    room_setup_by_user(:a)
    clock_open
    clock_play_button_click
    assert_text "先に順番設定をしよう"
  end

  it "順番設定ONにしたが対局者を指定せずに対局開始ボタンを押した場合" do
    room_setup_by_user(:a)
    order_modal_open
    os_switch_toggle
    order_modal_close
    order_modal_close_force
    clock_open
    clock_play_button_click
    assert_text "先に順番設定で対局者を指定しよう"
  end
end
