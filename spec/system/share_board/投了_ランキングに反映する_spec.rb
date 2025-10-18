require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name    => user_name,
        :fixed_member => "a,b",
        :fixed_order  => "a,b",
        :room_create_after_action => :cc_auto_start,
      })
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_a do
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
end
