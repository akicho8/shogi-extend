require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name            => :alice,
        :fixed_member   => "alice,bob",
        :fixed_order    => "alice,bob",
        :fixed_order_state    => "to_o2_state",
        :autoexec             => "honpu_main_setup",
      })
    assert_honpu_open_on        # 本譜がある
    clock_start                 # 対局開始
    assert_honpu_open_off       # 本譜が消えた
  end
end
