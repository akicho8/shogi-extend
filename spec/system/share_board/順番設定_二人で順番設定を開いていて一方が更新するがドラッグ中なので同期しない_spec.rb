require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    visit_app({
        :room_key            => :test_room,
        :user_name      => user_name,
        :fixed_member_names   => "a,b",
        :fixed_order_names    => "a,b",
        :fixed_order_state    => "to_o2_state",
        :handle_name_validate => "false",
        :autoexec             => "os_modal_open_handle",
      })
  end

  xit "works" do
    a_block { case1("a") }           # a が順番設定を開いた
    b_block { case1("b") }           # b が順番設定を開いた
    b_block do
      # ここでドラッグ中にする
      # TODO: 方法がわからない
    end
    a_block do
      find(".swap_handle").click     # a が先後反転した
      os_submit_button_click                  # a が確定を押した
    end
    b_block do
      assert_order_team_one "a", "b" # b に反映されていない
    end
  end
end
