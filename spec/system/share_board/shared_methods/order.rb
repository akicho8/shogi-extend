module SharedMethods
  def os_modal_handle
    find(".os_modal_handle").click
  end

  # 順番設定と対局時計の右上の有効をトグルする
  def os_switch_toggle
    # 本当は find(:checkbox, "有効", exact: true).click と書きたいがなぜか動かない
    find("label", :class => "main_switch", text: "有効", exact_text: true).click
  end

  def order_set_on
    order_modal_main_switch_click(true)
  end

  def order_set_off
    order_modal_main_switch_click(false)
  end

  def order_modal_main_switch_click(enabled)
    hamburger_click
    os_modal_handle                        # 「順番設定」モーダルを開く
    os_switch_toggle                         # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信←やめた)
    action_log_row_of(0).assert_text("順番 #{enabled ? 'ON' : 'OFF'}")
    if enabled
      apply_button                          # 明示的に適用する
    end
    modal_close_handle                      # 閉じる (ヘッダーに置いている)
  end

  def apply_button
    first(".apply_button").click
  end

  def modal_close_handle
    first(".close_handle_for_capybara").click          # 閉じる (ヘッダーに置いている)
  end

  # klass の上からn番目のメンバーを観戦に移動する
  # klass: [dnd_black, dnd_white, dnd_both]
  def drag_to_watch(klass, n)
    a = find(".#{klass} li:nth-child(#{n.next})")
    b = find(".dnd_watch_users ul")
    a.drag_to(b)
  end

  def assert_order_on
    assert_system_variable(:order_enable_p, true)
  end

  def assert_order_setting_members(names)
    result = all(".TeamsContainer tbody .user_name").collect(&:text)
    assert { result == names }
  end

  def __assert_order_team_one(klass, names)
    result = all(".#{klass} li").collect(&:text).join
    assert { result == names }
  end

  def assert_order_team_one(black, white)
    __assert_order_team_one "dnd_black", black
    __assert_order_team_one "dnd_white", white
  end
end
