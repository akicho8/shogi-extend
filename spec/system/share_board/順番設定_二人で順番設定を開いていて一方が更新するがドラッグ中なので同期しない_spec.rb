require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name    => user_name,
        :fixed_member => "a,b",
        :fixed_order  => "a,b",
      })
    os_modal_open
    os_switch_toggle
  end

  xit "works" do
    window_a { case1("a") }           # a が順番設定を開いた
    window_b { case1("b") }           # b が順番設定を開いた
    window_b do
      # ここでドラッグ中にする
      # TODO: 方法がわからない
    end
    window_a do
      find(".swap_handle").click     # a が先後反転した
      os_submit_button_click                  # a が確定を押した
    end
    window_b do
      assert_order_team_one "a", "b" # b に反映されていない
    end
  end
end
