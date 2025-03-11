module SharedMethods
  # 順番OFF 時計STOP
  def assert_order_off_and_clock_stop
    assert_system_variable("order_enable_p", "false")
    assert_system_variable("clock_box.current_status", "stop")
  end

  def os_modal_handle
    find(".os_modal_handle").click
  end

  def os_modal_open
    global_menu_open
    os_modal_handle
  end

  def os_modal_close
    find(".OrderSettingModal .close_handle_for_capybara").click
  end

  def os_modal_close_force
    find("button", text: "確定せずに閉じる", exact_text: true).click
  end

  # 順番設定と対局時計の右上の有効をトグルする
  def os_switch_toggle
    Capybara.find(".modal .main_switch").click
  end

  def order_set_on
    os_modal_open
    os_switch_toggle                       # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信←やめた)
    os_submit_button_click                 # 明示的に適用する
    os_modal_close
    assert_action_text("順番 ON")
  end

  def order_set_off
    os_modal_open
    os_switch_toggle                       # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信←やめた)
    os_modal_close
    assert_action_text("順番 OFF")
  end

  def os_submit_button_click
    first(".os_submit_button_for_capybara").click
  end

  def apply_button
    first(".apply_button").click
  end

  def os_modal_force_submit
    first(".os_modal_force_submit_button").click
  end

  # klass の上からn番目のメンバーを観戦に移動する
  # klass: [dnd_black, dnd_white, dnd_both]
  def drag_to_watch(klass, n)
    a = find(".#{klass} li:nth-child(#{n.next})")
    b = find(".dnd_watch_users ul")
    # forceFallback: true によって drag_to が動かなくなるため revert した
    # https://github.com/SortableJS/Vue.Draggable/issues/1156#issuecomment-1340558451
    a.drag_to(b)
  end

  def assert_order_on
    assert_system_variable(:order_enable_p, true)
  end

  def assert_order_off
    assert_system_variable(:order_enable_p, false)
  end

  def assert_order_setting_members(names)
    result = all(".TeamsContainer tbody .user_name").collect(&:text)
    assert { result == names }
  end

  # 順番設定画面内の黒白チームの人たち
  def assert_order_team_one(black, white, options = {})
    __assert_order_dnd_team_one("dnd_black", black, options)
    __assert_order_dnd_team_one("dnd_white", white, options)
  end

  # 順番設定画面内の観戦者の人たち
  def assert_order_dnd_watcher(users, options = {})
    __assert_order_dnd_team_one("dnd_watch_users", users, options)
  end

  def __assert_order_dnd_team_one(klass, names_str, options)
    names = all(".#{klass} li").collect(&:text)
    if options[:sort]
      names = names.sort
    end
    assert { names.join == names_str }
  end
end
