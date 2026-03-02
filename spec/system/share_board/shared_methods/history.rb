module SharedMethods
  # 完全一致のテキストがあること
  def assert_history_text(text)
    within(".XhistoryContainer") do
      assert_selector(:element, text: text, exact_text: true)
    end
  end

  # 完全一致のテキストがないこと
  def assert_no_history_text(text)
    within(".XhistoryContainer") do
      assert_no_selector(:element, text: text, exact_text: true)
    end
  end

  # 履歴の上から index 目の行
  def history_items_at(index)
    find(".XhistoryContainer .SbAvatarLine:nth-child(#{index.next})")
  end

  # 履歴の index 番目は user が behavior した
  def assert_history_index_behavior(index, user, behavior)
    within(history_items_at(index)) do
      assert_selector(:element, text: user,     exact_text: true)
      assert_selector(:element, text: behavior, exact_text: true)
    end
  end

  # 履歴の user が behavior した
  def assert_history(user, behavior)
    within(".XhistoryContainer") do
      assert_selector(:element, text: user,     exact_text: true)
      assert_selector(:element, text: behavior, exact_text: true)
    end
  end
end
