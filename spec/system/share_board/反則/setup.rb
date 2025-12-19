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

  def modal_exist
    assert_selector(".IllegalLoseModal", text: "二歩で☖の勝ち")
  end

  def modal_none
    assert_no_selector(".IllegalLoseModal")
  end

  def action_log_exist
    assert_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
  end

  def action_log_none
    assert_no_selector(".SbActionLog .flex_item", text: "二歩", exact_text: true)
  end
end

RSpec.configure do |config|
  config.include(mod, type: :system, share_board_spec: true)
end
