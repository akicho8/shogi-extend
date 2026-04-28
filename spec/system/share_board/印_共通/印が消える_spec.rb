require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case2(user_name)
    visit_room(user_name: user_name, origin_mark_behavior_key: :omb_with_self)
  end

  def case1
    window_a { case2(:a) }
    window_b { case2(:b) }

    # 本譜と変化を作る
    window_a { piece_move_o("77", "76", "☗7六歩") } # 1手目を指す
    window_a { shortcut_send("W") }                 # 本譜を作る
    window_b { piece_move_o("33", "34", "☖3四歩") } # 2手目を指す (変化する)

    # 思考印をつける
    window_a { board_place("59").right_click } # 互いに玉の位置に印をつける
    window_b { board_place("51").right_click } # 互いに玉の位置に印をつける

    # 持ち上げる
    window_a { board_place("59").click }       # 3手目で a が持ち上げる

    # 各操作後に印が消える
    window_a { assert_lift_exist }
    window_a { assert_origin_mark_exist }
    window_b { assert_origin_mark_exist }
    window_a { assert_think_mark_exist }
    window_b { assert_think_mark_exist }
    window_a { yield }
    window_a { assert_lift_none }        # 持ち上げてない
    window_a { assert_origin_mark_none } # 移動元印が消えた
    window_b { assert_origin_mark_none } # 移動元印が消えた
    window_a { assert_think_mark_none }  # 思考印が消えた
    window_b { assert_think_mark_none }  # 思考印が消えた
  end

  it "変化から本譜に戻る" do
    case1 do
      find(".honpu_direct_return_handle").click
    end
  end

  it "本譜から本譜に戻る" do
    case1 do
      shortcut_send("h") # 本譜モーダルを開く
      find(".time_machine_modal_apply_handle").click         # 最後の局面に戻る
    end
  end

  it "スライダーを動かす" do
    case1 do
      window_a { sp_controller_click("first") }              # a が 0 手目に戻す (debounce の leading が発動するためすぐにブロードキャストする)
    end
  end

  it "初期配置に戻す" do
    case1 do
      sidebar_open                                           # サイドバーから
      find(".reflector_turn_zero_handle").click              # 「初期配置に戻す」を押す
      sidebar_close
    end
  end

  it "指す" do
    case1 do
      board_place("58").click
    end
  end
end
