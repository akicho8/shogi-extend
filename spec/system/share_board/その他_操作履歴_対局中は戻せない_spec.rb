require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name         => user_name,
        :FIXED_MEMBER      => "a,b",
        :FIXED_ORDER       => "a,b",
        :room_after_create => :cc_auto_start_10m,
      })
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_a { piece_move_o("77", "76", "☗7六歩") }
    window_b { piece_move_o("33", "34", "☖3四歩") }
    window_a do
      assert_turn(2)
      history_items_at(1).click                        # 上から2番目、つまり1手目の履歴を選択する
      find(".time_machine_modal_apply_handle").click   # 「X手目まで戻る」を押す
      assert_text "安全のため対局中の実行を制限しています"             # しかし、戻れない
      assert_turn(2)                                   # 2手目のまま
    end
  end
end
