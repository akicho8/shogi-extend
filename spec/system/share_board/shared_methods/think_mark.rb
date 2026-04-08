module SharedMethods
  def think_mark_toggle_button_click
    find(".think_mark_toggle_button_click_handle").click
  end

  def assert_click_then_think_mark
    board_place("76").click
    assert_selector(".ThinkMarkLayer")
  end

  def assert_abc_think_marks(expected)
    actual = [
      window_a { has_selector?(".ThinkMarkLayer") } ? "o" : "x",
      window_b { has_selector?(".ThinkMarkLayer") } ? "o" : "x",
      window_c { has_selector?(".ThinkMarkLayer") } ? "o" : "x",
    ].join

    assert { actual == expected }
  end

  def assert_think_mark_exist
    assert_selector(".ThinkMarkLayer", wait: 1)
  end

  def assert_think_mark_none
    assert_no_selector(".ThinkMarkLayer", wait: 1)
  end
end
