require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name    => :a,
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER  => "a,b",
        :autoexec     => "honpu_main_setup",
      })
    assert_honpu_open_on        # 本譜がある
    clock_start                 # 対局開始
    assert_honpu_open_off       # 本譜が消えた
  end
end
