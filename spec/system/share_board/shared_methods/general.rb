module SharedMethods
  def assert_var(key, value, **options)
    assert_selector(".assert_var .panel-block", text: "#{key}:#{value}", exact_text: true, **options)
  end

  def assert_no_var(key, value, **options)
    assert_no_selector(".assert_var .panel-block", text: "#{key}:#{value}", exact_text: true, **options)
  end

  def room_recreate_apply
    sidebar_open
    menu_item_click("再起動")     # モーダルを開く
    apply_button  # 実行する
  end

  def buefy_dialog_button_click(type = "")
    find(".modal button#{type}").click
  end

  # 手合割選択
  def preset_select(preset_key)
    sidebar_open
    menu_item_click("手合割")
    find(".PresetSelectModal .board_preset_key").select(preset_key)
    find(".apply_button").click
  end

  def kifu_read_run
    sidebar_open
    menu_item_click("棋譜の入力")
    find(".KifuReadModal textarea").set("68S", clear: :backspace)
    find(".KifuReadModal .submit_handle").click
  end
end
