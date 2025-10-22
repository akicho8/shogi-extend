module SharedMethods
  # 「投了」を押してモーダルを表示する
  def give_up_modal_open_handle
    find("a", text: "投了", exact_text: true).click
    assert_give_up_modal
  end

  def give_up_run
    give_up_modal_open_handle
    find(:button, "投了する").click # モーダルが表示されるので本当に投了する
  end

  # 投了ボタンがある
  def assert_give_up_button
    assert_selector("a", text: "投了", exact_text: true)
  end

  # 投了モーダルがある
  def assert_give_up_modal
    assert_selector(".GiveUpModal")
  end

  # 投了モーダルがない
  def assert_no_give_up_modal
    assert_no_selector(".GiveUpModal")
  end
end
