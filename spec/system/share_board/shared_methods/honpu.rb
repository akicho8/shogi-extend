module SharedMethods
  def assert_honpu_open_on
    assert_selector(".SbNavbar .honpu_modal_open_handle", wait: 10)
  end

  def assert_honpu_open_off
    assert_no_selector(".SbNavbar .honpu_modal_open_handle")
  end

  def assert_honpu_return_on
    assert_selector(".SbNavbar .honpu_direct_return_handle", wait: 10)
  end

  def assert_honpu_return_disabled
    assert_selector(".SbNavbar .honpu_direct_return_handle[disabled]")
  end

  def assert_honpu_return_active
    assert_selector(".SbNavbar .honpu_direct_return_handle:not([disabled])")
  end
end
