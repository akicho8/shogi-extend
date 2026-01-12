require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name         => "a",
        :FIXED_MEMBER      => "a,b",
        :FIXED_ORDER       => "a,b",
        :room_after_create => :cc_auto_start_10m,
        :RESEND_FEATURE         => false,
      })
    piece_move("88", "55") # 55角を指した瞬間にモーダルが出ているため piece_move_o でのチェックはできない
    assert_selector(".EndingModal")
    ending_modal_close_handle
    assert_order_off
  end
end
