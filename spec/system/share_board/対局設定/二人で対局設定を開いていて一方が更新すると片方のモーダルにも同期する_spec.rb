require "#{__dir__}/setup"

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
    window_a do
      sidebar_open
      order_modal_open_handle               # a が対局設定を開いた
    end
    window_b do
      sidebar_open
      order_modal_open_handle                # b が対局設定を開いた
    end
    window_a do
      find(".swap_handle").click     # a が先後反転した
      order_submit_handle         # a が確定を押した (ここで b の対局設定も閉じている)
    end
    window_b do
      order_modal_open_handle        # b が再度、対局設定を開いた
      assert_order_team_one "b", "a" # b に反映されているのがわかる
    end
  end
end
