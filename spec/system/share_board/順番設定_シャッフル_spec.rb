require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(button_name)
    visit_app({
        :room_key            => :test_room,
        :user_name            => "1",
        :fixed_member_names   => "1,2,3,4,5,6,7,8",
        :fixed_order_names    => "1,2,3,4,5,6,7,8",
        :fixed_order_state    => "to_o2_state",
        :handle_name_validate => "false",
        :autoexec             => "os_modal_open_handle",
      })
    os_modal_close
    assert_system_variable("仮順序", "12345678")
    os_modal_open
    find(:button, text: button_name, exact_text: true).click
    assert_text("1さんが#{button_name}しました", wait: 5)
    os_modal_close
    os_modal_close_force
    assert_no_system_variable("仮順序", "12345678")
  end

  it "works" do
    case1("全体ｼｬｯﾌﾙ")
    case1("ﾁｰﾑ内ｼｬｯﾌﾙ")
  end
end
