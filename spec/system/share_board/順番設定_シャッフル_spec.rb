require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1
    visit_app({
        :room_code            => :test_room,
        :user_name      => "1",
        :fixed_member_names   => "1,2,3,4,5,6,7,8",
        :fixed_order_names    => "1,2,3,4,5,6,7,8",
        :fixed_order_state    => "to_o2_state",
        :handle_name_validate => "false",
        :autoexec             => "os_modal_handle",
      })
  end

  it "works" do
    case1
    assert_system_variable("順序2", "12345678")
    find(".shuffle_handle").click
    assert_text("1さんがシャッフルしました", wait: 60)
    assert_no_system_variable("順序2", "12345678")
  end
end
