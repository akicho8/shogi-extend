module SharedMethods
  def clock_box_set(initial_main_min, initial_read_sec, initial_extra_sec, every_plus)
    find(".initial_main_min input").set(initial_main_min)   # 持ち時間(分)
    find(".initial_read_sec input").set(initial_read_sec)   # 秒読み
    find(".initial_extra_sec input").set(initial_extra_sec) # 猶予(秒)
    find(".every_plus input").set(every_plus)               # 1手毎加算(秒)
  end

  def clock_box_values
    [
      find(".initial_main_min input").value,
      find(".initial_read_sec input").value,
      find(".initial_extra_sec input").value,
      find(".every_plus input").value,
    ].collect(&:to_i)
  end

  def clock_box_values_eq(expected)
    result = clock_box_values   # 必ず変数に入れないと power_assert が死ぬ
    is_asserted_by { result == expected }
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
    hamburger_click
    cc_modal_handle             # 「対局時計」モーダルを開く
    assert_clock_off            # 時計はまだ設置されていない
    clock_switch_toggle          # 設置する
    assert_clock_on             # 時計が設置された
  end

  # 順番設定済みの状態で対局時計を設置してPLAY押して閉じる
  def clock_start
    clock_open                               # 対局時計を開いて
    find(".play_button").click               # 開始
    find(".close_handle_for_capybara").click # 閉じる (ヘッダーに置いている)
  end

  # 順番設定をしてください状態で対局時計を設置してPLAY押して閉じる
  # 順番設定をしてくださいのダイアログが出るが「無視して開始する」
  def clock_start_force
    clock_open                                     # 対局時計を開いて
    find(".play_button").click                     # 開始
    find(".dialog.modal .button.is-warning").click # 「無視して開始する」
    find(".close_handle_for_capybara").click       # 閉じる (ヘッダーに置いている)
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

  def cc_at(n)
    ".cc_form_block:nth-child(#{n})"
  end

  def cc_form_block_eq(n, values)
    result = Capybara.within(cc_at(n)) { clock_box_values }
    is_asserted_by { result == values }
  end

  def cc_in(n, &block)
    Capybara.within(cc_at(n), &block)
  end

  def cc_modal_handle
    find(".cc_modal_handle").click
  end

  def clock_switch_toggle
    find("label", class: "main_switch", text: "設置", exact_text: true).click
  end

  def assert_white_read_sec(second)
    v = find(".is_white .read_sec").text.to_i
    is_asserted_by { v == second || v == second.pred }
  end
end
