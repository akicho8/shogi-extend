module SharedMethods
  # スコープを合わせる
  def action_log_scope(&block)
    within(".SbActionLog", &block)
  end

  # 完全一致のテキストがあること
  def action_assert_text(text)
    action_log_scope do
      assert_selector("div", text: text, exact_text: true)
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

  def assert_action(user, behavior)
    within(".SbActionLog") do
      assert_selector(:element, text: user,     exact_text: true)
      assert_selector(:element, text: behavior, exact_text: true)
    end
  end
end
