module SharedMethods
  # 完全一致のテキストがあること
  def assert_action_text(text)
    within(".SbActionLog") do
      assert_selector(:element, text: text, exact_text: true)
    end
  end

  # 履歴の上から index 目の行
  def action_log_row_of(index)
    find(".SbActionLog .SbAvatarLine:nth-child(#{index.next})")
  end

  # 履歴の index 番目は user が behavior した
  def assert_action_index(index, user, behavior)
    within(action_log_row_of(index)) do
      assert_selector(:element, text: user,     exact_text: true)
      assert_selector(:element, text: behavior, exact_text: true)
    end
  end

  # 履歴の user が behavior した
  def assert_action(user, behavior)
    within(".SbActionLog") do
      assert_selector(:element, text: user,     exact_text: true)
      assert_selector(:element, text: behavior, exact_text: true)
    end
  end
end
