require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "スライダーがキャンセルされる" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a { piece_move_o("77", "76", "☗7六歩") }
    window_b { piece_move_o("33", "34", "☖3四歩") }
    window_b { sp_controller_click("first") }        # bは「すぐに」最初の局面に戻した。b からは1秒後に reflector_call が実行されるのだが、そのときにはすでに4手目まで進んでいる
    window_a { piece_move_o("27", "26", "☗2六歩") } # reflector_call が呼ばれるよりも前に3手目が指され、
    window_b { piece_move_o("83", "84", "☖8四歩") } # 続いて4手目も指されると
    window_a { assert_turn(4) }                      # 仕様としては微妙だが4手目まで進む。つまりスライダー操作は無視されたとも言える
  end

  it "本来の意図した動作" do
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a { piece_move_o("77", "76", "☗7六歩") } # 1手目
    window_b { piece_move_o("33", "34", "☖3四歩") } # 2手目
    window_b { sp_controller_click("first") }        # 0手目に戻す (1秒後に反映する)
    window_a { assert_turn(0) }                      # 0 手目になるまで待つ
    window_a { piece_move_o("27", "26", "☗2六歩") } # 1手目
    window_b { piece_move_o("83", "84", "☖8四歩") } # 2手目
    window_a { assert_turn(2) }
  end
end
