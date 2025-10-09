require "#{__dir__}/../shared_methods"

module SharedMethods
  def think_mark_toggle_button_click
    find(".think_mark_toggle_button_click_handle").click
  end

  def click_try_at_76
    place_click("76")
  end

  def assert_click_then_mark
    click_try_at_76
    assert_selector(".ThinkMark")
  end

  def assert_abc_marks(expected)
    actual = [
      window_a { has_selector?(".ThinkMark") } ? "o" : "x",
      window_b { has_selector?(".ThinkMark") } ? "o" : "x",
      window_c { has_selector?(".ThinkMark") } ? "o" : "x",
    ].join

    assert { actual == expected }
  end

  def king_vs_king_sfen
    "position sfen 4k4/9/9/9/9/9/9/9/4K4 b RB2G2S2N2L9Prb2g2s2n2l9p 1"
  end
end
