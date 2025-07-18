require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(shuffle_first)
    visit_app({
        :room_key            => :test_room,
        :user_name            => "1",
        :fixed_member_names   => "1,2,3,4,5,6,7,8",
        :fixed_order_state    => "to_o2_state",
        :handle_name_validate => "false",
        :autoexec             => "os_modal_open_handle",
        :shuffle_first        => shuffle_first,
      })
    os_switch_toggle
    os_modal_close
    os_modal_close_force
  end

  it "無効" do
    case1(false)
    assert_system_variable("仮順序", "12345678")
  end

  it "有効(初期値)" do
    case1(true)
    assert_no_system_variable("仮順序", "12345678")
  end
end
