require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :room_key            => :test_room,
        :user_name            => user_name,
        :fixed_member_names   => "a,b",
        :fixed_order_names    => "a,b",
        :fixed_order_state    => "to_o2_state",
        :handle_name_validate => "false",
      })
  end

  it "works" do
    a_block { case1("a") }           # a が入室
    b_block { case1("b") }           # b が入室
    a_block { os_modal_open }        # a が順番設定を開いた
    b_block { os_modal_open }        # b が順番設定を開いた
    a_block do
      find(".swap_handle").click     # a が先後反転した
      os_submit_button_click                   # a が確定を押した
    end
    b_block do
      assert_order_team_one "b", "a" # b に反映されている
    end
  end
end
