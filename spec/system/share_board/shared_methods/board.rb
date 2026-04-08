module SharedMethods
  include ShogiPlayerMethods

  # turn 手目
  def assert_turn(turn)
    assert_text("current_turn:#{turn}")
  end

  # 棋譜はX手目まである
  def assert_turn_max(turn)
    assert_text("current_turn_max:#{turn}")
  end

  # 駒移動できる
  def piece_move_o(from, to, human)
    piece_move(from, to)
    assert_text(human)
  end

  # 駒移動できない
  def piece_move_x(from, to, human)
    piece_move(from, to)
    assert_no_text(human)
  end

  def turn_minus_one
    sidebar_open
    find(".turn_change_to_previous_modal_open_handle").click # 「1手戻す」モーダルを開く
    find(".turn_change_call_handle").click                   # 「N手目まで戻る」
  end

  def assert_lift_exist
    assert_selector(".lifted_from_p")
  end

  def assert_lift_none
    assert_no_selector(".lifted_from_p")
  end
end
