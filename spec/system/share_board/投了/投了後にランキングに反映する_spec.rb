require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    setup_share_board
    visit_room({
        :user_name    => :a,
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER  => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    resign_run
    sidebar_open
    menu_item_click("対局履歴")
    within(".modal") do
      assert_text(:a)
      assert_text(:b)
    end
    find(".permalink").click
    assert_text("順位")
  end
end
