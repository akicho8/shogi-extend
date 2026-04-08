module SharedMethods
  def assert_click_then_origin_mark
    board_place("58").click
    assert_selector(".OriginMarkLayer")
  end

  def assert_abc_origin_marks(expected)
    actual = [
      window_a { has_selector?(".OriginMarkLayer") } ? "o" : "x",
      window_b { has_selector?(".OriginMarkLayer") } ? "o" : "x",
      window_c { has_selector?(".OriginMarkLayer") } ? "o" : "x",
    ].join

    assert { actual == expected }
  end

  def assert_origin_mark_exist
    assert_selector(".OriginMarkLayer", wait: 1)
  end

  def assert_origin_mark_none
    assert_no_selector(".OriginMarkLayer", wait: 1)
  end
end
