require "#{__dir__}/../shared_methods"

mod = Module.new do
  def sfen
    "position sfen 8+r/8B/7PK/9/9/9/9/9/9 b P 1"
  end

  def double_pawn!
    stand_piece(:black, :P).click
    board_place("22").click
  end

  def notice_exist
    assert_var(:latest_illegal_name, "二歩")
  end

  def notice_none
    assert_var(:illegal_params, "")
  end

  def lose_modal_exist
    assert_selector(".IllegalLoseModal", text: "二歩で☖の勝ち")
  end

  def lose_modal_none
    assert_no_selector(".IllegalLoseModal")
  end

  def takeback_modal_exist
    assert_selector(".IllegalTakebackModal", text: "二歩")
  end

  def takeback_modal_none
    assert_no_selector(".IllegalTakebackModal")
  end

  def action_log_exist
    assert_selector(".SbActionLogContainer .flex_item", text: "二歩", exact_text: true)
  end

  def action_log_none
    assert_no_selector(".SbActionLogContainer .flex_item", text: "二歩", exact_text: true)
  end

  ################################################################################

  def assert_resign_success
    assert_action "a", "投了"
    assert_clock(:stop)
    takeback_modal_none
    assert_turn(1)              # 反則手を反映した局面に進んでいる
  end

  def assert_resign_ng
    assert_clock(:pause)
    takeback_modal_exist
  end

  def assert_takeback_success
    assert_action_text("時計再開")
    assert_clock(:play)
    takeback_modal_none
    assert_turn(0)              # 反則前の局面
  end

  def assert_takeback_ng
    find(".illegal_takeback_modal_submit_handle_takeback").click
    assert_clock(:pause)
    takeback_modal_exist
  end

  ################################################################################

  # SfenInfo.fetch("連続王手の千日手確認用") 用の発動手順
  def perpetual_check_trigger
    3.times do
      piece_move_o("25", "24", "☗2四飛")
      piece_move_o("14", "15", "☖1五玉")

      piece_move_o("24", "25", "☗2五飛")
      piece_move_o("15", "14", "☖1四玉")
    end

    piece_move("25", "24")                 # 4回目の同一局面の王手
  end
end

RSpec.configure do |config|
  config.include(mod, type: :system, share_board_spec: true)
end
