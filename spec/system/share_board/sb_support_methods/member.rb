module SbSupportMethods
  # メンバーの状態
  def assert_member_status(user_name, klass, options = {})
    assert_selector(".SbMemberList .#{klass} .user_name", { text: user_name, exact_text: true }.merge(options))
  end

  # メンバーの位置
  def assert_member_index(user_name, i)
    assert_selector(".SbMemberOne:nth-child(#{i}) .user_name", text: user_name, exact_text: true)
  end

  # メンバーが存在する
  def assert_member_exist(user_name)
    assert_selector(".SbMemberList .user_name", text: user_name, exact_text: true, wait: 5)
  end

  # メンバーが存在しない
  def assert_member_missing(user_name)
    assert_no_selector(".SbMemberList .user_name", text: user_name, exact_text: true)
  end

  # メンバーリストの上ら i 番目をクリック
  def member_list_click_nth(i)
    assert_selector(".SbMemberOne", wait: 30)
    find(".SbMemberOne:nth-child(#{i})").click
  end

  # メンバーリストの指定の名前をクリック
  def member_list_name_click(name)
    find(".SbMemberList .user_name", text: name, exact_text: true).click
  end

  # 指定のメンバーは指定のテキストを持っている
  def assert_member_has_text(user_name, text)
    el = find(".SbMemberOne .user_name", text: user_name, exact_text: true, wait: 10).find(:xpath, "..")
    el.assert_selector(:element, text: text, exact_text: true)
  end
end
