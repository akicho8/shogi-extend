require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    room_setup_by_user(:a)
    clock_open
    clock_box_form_set(:black, 61, 0, 0, 0)
    clock_play_button_click
    assert_text "持ち時間は60分以内にしよう"
  end
end
