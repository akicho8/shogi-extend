module SharedMethods
  def assert_honpu_open_on
    assert_selector(".SbNavbar .honpu_open_button", wait: 10)
  end

  def assert_honpu_open_off
    assert_no_selector(".SbNavbar .honpu_open_button")
  end

  def assert_honpu_return_on
    assert_selector(".SbNavbar .honpu_return_button", wait: 10)
  end

  def assert_honpu_return_off
    assert_no_selector(".SbNavbar .honpu_return_button")
  end
end
