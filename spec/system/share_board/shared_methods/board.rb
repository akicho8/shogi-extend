module SharedMethods
  include ShogiPlayerMethods

  # turn 手目
  def assert_turn(turn)
    assert_text("current_turn:#{turn}", wait: 10)
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
    global_menu_open
    find(".turn_change_to_previous_modal_open_handle").click # 「1手戻す」モーダルを開く
    find(".apply_button").click                              # 「N手目まで戻る」
  end
end
