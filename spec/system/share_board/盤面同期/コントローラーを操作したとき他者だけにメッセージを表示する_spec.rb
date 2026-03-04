require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room(:user_name => user_name)
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }
    window_a { piece_move_o("77", "76", "☗7六歩") }
    window_a { sp_controller_click(:previous) }
    window_a { assert_no_text("aさんが初期配置に戻しました") } # aさんが操作したけどaさんに自分が操作したことはわかっているので表示しない
    window_b { assert_text("aさんが初期配置に戻しました") }    # bさんはいきなり盤面が変化したことに驚いているためその理由を伝えてあげる
    window_b { sp_controller_click(:last) }                    # 同様にbさんが操作した場合、
    window_b { assert_no_text("bさんが1手目に進めました") }    # 自分が操作したことはわかっているので表示しない
    window_a { assert_text("bさんが1手目に進めました") }       # aさんはいきなり盤面が変化したことに驚いているためその理由を伝えてあげる
  end
end
