require "#{__dir__}/../shared_methods"

module SharedMethods
  def assert_click_then_mark
    place_click("76")
    assert_selector(".ThinkMark")
  end

  def assert_abc_marks(expected)
    actual = [
      a_block { has_selector?(".ThinkMark") } ? "o" : "x",
      b_block { has_selector?(".ThinkMark") } ? "o" : "x",
      c_block { has_selector?(".ThinkMark") } ? "o" : "x",
    ].join

    assert { actual == expected }
  end
end
