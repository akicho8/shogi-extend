require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    setup_share_board
    visit_room({
        :user_name    => :a,
        :fixed_member => "a,b",
        :fixed_order  => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
    give_up_run
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
