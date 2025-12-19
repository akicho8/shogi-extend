require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name         => :a,
        :FIXED_MEMBER      => "a,b",
        :FIXED_ORDER       => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    resign_run
    assert_text "棋譜は上の本譜ボタンからコピーできます"
  end
end
