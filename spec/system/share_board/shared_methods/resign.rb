module SharedMethods
  # 「投了」を押してモーダルを表示する
  def resign_confirm_modal_open_handle
    find("a", text: "投了", exact_text: true).click
    assert_resign_confirm_modal
  end

  # 投了
  def resign_run
    resign_confirm_modal_open_handle
    find(:button, "投了する").click # モーダルが表示されるので本当に投了する
    ending_modal_close_handle
  end

  # 投了ボタンがある
  def assert_resign_button
    assert_selector("a", text: "投了", exact_text: true)
  end

  # 投了モーダルがある
  def assert_resign_confirm_modal
    assert_selector(".ResignConfirmModal")
  end

  # 投了モーダルがない
  def assert_no_resign_confirm_modal
    assert_no_selector(".ResignConfirmModal")
  end

  # 最後のモーダルを閉じる
  def ending_modal_close_handle
    find(".ending_modal_close_handle").click
  end

  def assert_ending_illegal(name)
    assert_var(:illegal_names_str, name)
  end

  def assert_ending_modal_exist
    assert_selector(".EndingModal")
  end

  def assert_ending_modal_none
    assert_no_selector(".EndingModal")
  end
end
