require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name    => user_name,
        :FIXED_MEMBER => "a,b",
        :FIXED_ORDER  => "a,b",
      })
  end

  it "works" do
    window_a { case1(:a) }           # a が入室
    window_b { case1(:b) }           # b が入室
    window_a { os_modal_open }       # a が順番設定を開いた
    window_b { os_modal_open }       # b が順番設定を開いた
    window_a do
      find(".swap_handle").click     # a が先後反転した
      os_submit_button_click         # a が確定を押した
    end
    window_b do
      assert_order_team_one "b", "a" # b に反映されている
    end
  end
end
