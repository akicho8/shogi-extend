require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(auto_resign_key)
    initial_read_sec = 5
    visit_app({
        :room_key            => :test_room,
        :user_name            => "a",
        :fixed_member_names   => "a,b",
        :fixed_order_names    => "a,b",
        :handle_name_validate => "false",
        :fixed_order_state    => "to_o1_state",
        :clock_auto_start     => "true",
        :auto_resign_key      => auto_resign_key,
        **clock_box_params([0, initial_read_sec, 0, 0]),
      })
    sleep(initial_read_sec)
    assert_timeout_modal_exist
    cc_timeout_modal_close
  end

  it "無効だと順番設定は解除されていない" do
    case1("is_auto_resign_off")
    assert_order_on
  end

  it "有効だと順番設定は解除されている" do
    case1("is_auto_resign_on")
    assert_order_off
  end
end
