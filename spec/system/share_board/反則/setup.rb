require "#{__dir__}/../shared_methods"

mod = Module.new do
  def sfen
    "position sfen 8+r/8B/7PK/9/9/9/9/9/9 b P 1"
  end

  def double_pawn!
    stand_click(:black, :P)
    place_click("22")
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

  def block_modal_exist
    assert_selector(".IllegalBlockModal", text: "二歩")
  end

  def block_modal_none
    assert_no_selector(".IllegalBlockModal")
  end

  def action_log_exist
    assert_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
  end

  def action_log_none
    assert_no_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
  end

  ################################################################################

  def assert_resign_success
    find(".illegal_block_modal_submit_handle_resign").click
    assert_action "a", "投了"
    assert_clock(:stop)
    block_modal_none
    assert_turn(1)              # 反則手を反映した局面に進んでいる
  end

  def assert_resign_ng
    find(".illegal_block_modal_submit_handle_resign").click
    assert_clock(:pause)
    block_modal_exist
  end

  def assert_block_success
    find(".illegal_block_modal_submit_handle_block").click
    assert_clock(:play)
    block_modal_none
    assert_turn(0)              # 反則前の局面
  end

  def assert_block_ng
    find(".illegal_block_modal_submit_handle_block").click
    assert_clock(:pause)
    block_modal_exist
  end

  ################################################################################
end

RSpec.configure do |config|
  config.include(mod, type: :system, share_board_spec: true)
end
