module SharedMethods
  def setup_share_board
    sfen_info = SfenInfo["相全駒手番△"]
    eval_code %(ShareBoard.setup(force: true); ShareBoard::Room.mock(room_key: 'test_room', sfen: "#{sfen_info.sfen}"))
  end

  def room_create_delay
    (ENV["ROOM_CREATE_DELAY"] || 0).to_i
  end

  # System テスト時の環境はなるべく何もしていない方向にもっていってセットアップをシンプルにする
  # 元々はなるべくデフォルトを production に合わせていたが、それだと初期条件を用意するのが遠回りになる
  def visit_base_default_options
    {
      :room_restore_feature_p => false,             # 盤面を復元しない
      :room_create_delay      => room_create_delay, # 部屋作成直前の待ち秒数 (assert_room_created の wait より小さくする)
      :ng_word_check_p        => false,             # ハンドルネームのチェックをしない
      :room_url_copy_modal_p  => false,             # 部屋のリンクのコピーモーダルを出さない
      :auto_close_p           => false,             # 入退室・順番・時計を自動的に閉じない
      :self_vs_self_enable_p  => false,             # 自分vs自分禁止 (順番設定で対戦相手がいない場合はバリデーションする)
      :think_mark_invite_feature_p => false,        # 観戦者に促すか？
      :system_reserved_avatar_then_clear => false,             # 起動時の絵文字検証
    }
  end

  def visit_base(params = {})
    params = visit_base_default_options.merge(params.to_options)
    visit_to("/share-board", params)
  end

  def visit_app(params = {})
    visit_base(params)
  end

  def visit_room(params = {})
    params = {
      :room_key => :test_room,
    }.merge(params)

    visit_base(params)
    assert_room_created
  end

  def room_setup(room_key, user_name, params = {})
    visit_app(params)
    room_menu_open_and_input(room_key, user_name)
  end

  def room_setup_by_user(user_name, params = {})
    params = {
      :room_key => :test_room,
    }.merge(params.to_options)

    room_key = params.delete(:room_key)
    room_setup(room_key, user_name, params)
  end

  def room_menu_open_and_input(room_key, user_name)
    sidebar_open
    gate_modal_open_handle                        # 「入退室」を自分でクリックする
    Capybara.within(".GateModal") do
      find(".new_room_key input").set(room_key)   # 合言葉を入力する
      find(".new_user_name input").set(user_name) # ハンドルネームを入力する
      find(".gate_enter_handle").click            # 入室ボタンをクリックする
      # find(".close_handle").click                 # 閉じる
    end
    assert_text(user_name)                        # 入力したハンドルネームの人が参加している
    assert_room_created
  end

  def room_setup_by_fillin_params
    sidebar_open
    gate_modal_open_handle                  # 「入退室」を自分でクリックする
    Capybara.within(".GateModal") do
      find(".gate_enter_handle").click            # 入室ボタンをクリックする
      # find(".close_handle").click                 # 閉じる
    end
    assert_room_created
  end

  def room_auto_enter_but_confirm(user_name)
    assert_selector(".GateModal")               # 「入退室」のモーダルが自動的に表示されている
    Capybara.within(".GateModal") do
      find(".new_user_name input").set(user_name)  # ハンドルネームを入力する
      find(".gate_enter_handle").click          # 入室ボタンをクリックする
      # find(".close_handle").click               # 閉じる
    end
    assert_room_created
  end

  def assert_room_created
    assert_var("ac_room", "true", wait: room_create_delay + Capybara.default_max_wait_time) # wait は room_create_delay より大きくすること
  end

  def gate_modal_open_handle
    find(".gate_modal_open_handle").click
  end

  # 退室
  def gate_leave_handle
    sidebar_open
    gate_modal_open_handle        # 「入退室」を自分でクリックする
    first(".gate_leave_handle").click   # 退室ボタンをクリックする
    first(".close_handle").click   # 閉じる
  end

  # a と b が同じ部屋で2手目まで進めた状態
  def setup_a_b_turn2
    window_a { room_setup_by_user(:a) }
    window_b { room_setup_by_user(:b) }
    window_a { piece_move_o("77", "76", "☗7六歩") }
    window_b { piece_move_o("33", "34", "☖3四歩") }
    window_a { assert_turn(2) }
    window_b { assert_turn(2) }
  end
end
