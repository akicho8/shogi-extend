require "#{__dir__}/shared_methods"

RSpec.describe "投了_ランキングに反映する", type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :room_key           => :test_room,
        :user_name          => user_name,
        :fixed_member_names => "alice,bob",
        :fixed_order_names  => "alice,bob",
        :autoexec           => "cc_auto_start",
      })
  end

  it "works" do
    a_block do
      case1("alice")
    end
    b_block do
      case1("bob")
    end
    a_block do
      give_up_run
      global_menu_open
      menu_item_click("対局履歴")
      within(".modal") do
        assert_text("alice")
        assert_text("bob")
      end
      find(".permalink").click
      assert_text("順位")
    end
  end
end
