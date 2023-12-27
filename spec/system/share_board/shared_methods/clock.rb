module SharedMethods
  # ".ClockBoxInputTable td:nth-child(2) .initial_main_min input" → ☗ 持ち時間(分)
  # ".ClockBoxInputTable td:nth-child(3) .initial_main_min input" → ☖ 持ち時間(分)
  def cc_white_black_to_nth_child(location_key)
    { black: 2, white: 3 }.fetch(location_key)
  end

  def cc_input(location_key, input_class)
    index = cc_white_black_to_nth_child(location_key)
    ".ClockBoxInputTable td:nth-child(#{index}) .#{input_class}"
  end

  def clock_box_form_set(location_key, initial_main_min, initial_read_sec, initial_extra_sec, every_plus)
    find(cc_input(location_key, :initial_main_min)).find(:fillable_field).set(initial_main_min)                # 持ち時間(分)
    find(cc_input(location_key, :initial_read_sec)).find(:fillable_field).set(initial_read_sec)                # 秒読み
    find(cc_input(location_key, :initial_extra_sec)).find(:fillable_field).set(initial_extra_sec)              # 猶予(秒)
    find(cc_input(location_key, :every_plus)).find(:fillable_field).set(every_plus)                            # 1手毎加算(秒)
  end

  def clock_box_form_eq(location_key, initial_main_min, initial_read_sec, initial_extra_sec, every_plus)
    find(cc_input(location_key, :initial_main_min)).assert_selector(:fillable_field, with: initial_main_min)   # 持ち時間(分)
    find(cc_input(location_key, :initial_read_sec)).assert_selector(:fillable_field, with: initial_read_sec)   # 秒読み
    find(cc_input(location_key, :initial_extra_sec)).assert_selector(:fillable_field, with: initial_extra_sec) # 猶予(秒)
    find(cc_input(location_key, :every_plus)).assert_selector(:fillable_field, with: every_plus)               # 1手毎加算(秒)
  end

  def assert_clock_active_black
    assert_selector(".is_black .is_sclock_active")
    assert_selector(".is_white .is_sclock_inactive")
  end

  def assert_clock_active_white
    assert_selector(".is_black .is_sclock_inactive")
    assert_selector(".is_white .is_sclock_active")
  end

  def assert_clock_on
    assert_selector(".MembershipLocationPlayerInfoTime")
  end

  def assert_clock_off
    assert_no_selector(".MembershipLocationPlayerInfoTime")
  end

  def clock_open
    global_menu_open
    cc_modal_open_handle             # 「対局時計」モーダルを開く
    assert_clock_off            # 時計はまだ設置されていない
    clock_switch_toggle          # 設置する
    assert_clock_on             # 時計が設置された
  end

  def clock_modal_close
    find(".close_handle_for_capybara").click # 閉じる (ヘッダーに置いている)
  end

  # 順番設定済みの状態で対局時計を設置してPLAY押して閉じる
  def clock_start
    clock_open                               # 対局時計を開いて
    find(".play_button").click               # 開始
    clock_modal_close
  end

  # 順番設定をしてください状態で対局時計を設置してPLAY押して閉じる
  # 順番設定をしてくださいのダイアログが出るが「無視して開始する」
  def clock_start_force
    clock_open                                     # 対局時計を開いて
    find(".play_button").click                     # 開始
    find(".dialog.modal .button.is-warning").click # 「無視して開始する」
    clock_modal_close
  end

  # URLにする時計のパラメータ
  def clock_box_params(values)
    [
      :"clock_box.initial_main_min",
      :"clock_box.initial_read_sec",
      :"clock_box.initial_extra_sec",
      :"clock_box.every_plus",
    ].zip(values).to_h
  end

  def cc_modal_open_handle
    find(".cc_modal_open_handle").click
  end

  def clock_switch_toggle
    find("label", :class => "main_switch", text: "設置", exact_text: true).click
  end

  def assert_white_read_sec(second)
    assert_selector(".is_white .read_sec") { |e| [second, second.pred].include?(e.text.to_i) }
  end

  # 強制的に時間切れにする
  # モーダルがポップアップしていると押せないので注意
  def cc_timeout_trigger
    find(".cc_timeout_trigger").click
  end
end
