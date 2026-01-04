require "#{__dir__}/../shared_methods"

module SharedMethods
  def think_mark_toggle_button_click
    find(".think_mark_toggle_button_click_handle").click
  end

  def click_try_at_76
    board_place("76").click
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
end
