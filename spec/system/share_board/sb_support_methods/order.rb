module SbSupportMethods
  # 順番OFF 時計STOP
  def assert_order_off_and_clock_stop
    assert_order_off
    assert_clock(:stop)
  end

  def order_modal_open_handle
    find(".order_modal_open_handle").click
  end

  def order_modal_open
    # assert_room_created
    sidebar_open
    order_modal_open_handle
  end

  def order_modal_close
    find(".OrderModal .close_handle_for_capybara").click
  end

  def order_modal_close_force
    find("button", text: "確定せずに閉じる", exact_text: true).click
  end

  # 順番設定と対局時計の右上の有効をトグルする
  def os_switch_toggle
    Capybara.find(".modal .main_switch").click
  end

  def order_set_on
    order_modal_open
    os_switch_toggle                       # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信←やめた)
    os_submit_button_click                 # 明示的に適用する
    order_modal_close
    assert_action_text("順番 ON")
  end

  def order_set_off
    order_modal_open
    os_switch_toggle                       # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信←やめた)
    order_modal_close
    assert_action_text("順番 OFF")
  end

  def os_submit_button_click
    first(".os_submit_button_for_capybara").click
  end

  def apply_button
    first(".apply_button").click
  end

  def order_modal_force_submit
    first(".order_modal_force_submit_button").click
  end

  # from_klass の上から row_index 番目のメンバーを観戦に移動する
  def drag_to_watch(from_klass, row_index)
    drag_a_to_b(from_klass, row_index, "is_team_watcher")
  end

  # from_klass の上から row_index 番目のメンバーを to_klass に移動する
  # [is_team_black, is_team_white, is_team_both]
  def drag_a_to_b(from_klass, row_index, to_klass)
    from = find(".#{from_klass} .draggable_item:nth-child(#{row_index.next})")
    to = find(".#{to_klass} .draggable_area")
    # forceFallback: true によって drag_to が動かなくなるため revert した
    # https://github.com/SortableJS/Vue.Draggable/issues/1156#issuecomment-1340558451
    from.drag_to(to)
  end

  def assert_order_on
    assert_var(:order_enable_p, true)
  end

  def assert_order_off
    assert_var(:order_enable_p, false)
  end

  def assert_order_setting_members(names)
    result = all(".TeamsContainer tbody .user_name").collect(&:text)
    assert { result == names }
  end

  # 順番設定画面内の黒白チームの人たち
  def assert_order_team_one(black, white, options = {})
    __assert_order_dnd_team_one("is_team_black", black, options)
    __assert_order_dnd_team_one("is_team_white", white, options)
  end

  # 順番設定画面内の観戦者の人たち
  def assert_order_dnd_watcher(users, options = {})
    __assert_order_dnd_team_one("is_team_watcher", users, options)
  end

  def __assert_order_dnd_team_one(klass, names_str, options)
    names = all(".#{klass} .draggable_item").collect(&:text)
    if options[:sort]
      names = names.sort
    end
    assert { names.join == names_str }
  end
end
