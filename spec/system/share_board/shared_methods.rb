require "rails_helper"

module SharedMethods
  extend ActiveSupport::Concern

  included do
    include AliceBobCarol
  end

  def visit_app(*args)
    visit2("/share-board", *args)
  end

  def room_setup(room_code, user_name)
    visit_app
    hamburger_click
    room_setup_modal_handle        # 「部屋に入る」を自分でクリックする
    Capybara.within(".RoomSetupModal") do
      find(".new_room_code input").set(room_code) # 合言葉を入力する
      find(".new_user_name input").set(user_name) # ハンドルネームを入力する
      find(".entry_button").click                 # 共有ボタンをクリックする
      find(".close_handle").click                 # 閉じる
    end
    assert_text(user_name)                       # 入力したハンドルネームの人が参加している
  end

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
    assert { result == expected }
  end

  def assert_clock_active_black
    assert_selector(".is_black .is_sclock_active")
    assert_selector(".is_white .is_sclock_inactive")
  end

  def assert_clock_active_white
    assert_selector(".is_black .is_sclock_inactive")
    assert_selector(".is_white .is_sclock_active")
  end

  # 駒移動できる
  def piece_move_o(from, to, human)
    piece_move(from, to)
    assert_text(human)
  end

  # 駒移動できない
  def piece_move_x(from, to, human)
    piece_move(from, to)
    assert_no_text(human)
  end

  def piece_move(from, to)
    [from, to].each { |e| place_click(e) }
  end

  # place_click("76") は find(".place_7_6").click 相当
  def place_click(place)
    find(place_class(place)).click
  end

  def place_class(place)
    [".place", place.chars].join("_")
  end

  # place の位置の駒を持ち上げ中か？
  def lifted_from(place)
    assert_selector "#{place_class(place)}.lifted_from_p"
  end

  # place の位置の駒を持ち上げてない
  def no_lifted_from(place)
    assert_no_selector "#{place_class(place)}.lifted_from_p"
  end

  # OK or 観戦 トグルボタンのクリック
  def order_toggle(n)
    find(".TeamsContainer tbody tr:nth-child(#{n}) .enable_toggle_handle").click
  end

  def assert_white_read_sec(second)
    v = find(".is_white .read_sec").text.to_i
    assert { v == second || v == second.pred }
  end

  def assert_clock_on
    assert_selector(".MembershipLocationPlayerInfoTime")
  end

  def assert_clock_off
    assert_no_selector(".MembershipLocationPlayerInfoTime")
  end

  # 将棋盤内でプレイヤー名が表示されている
  def assert_has_sp_player_name
    assert_no_selector(".MembershipLocationPlayerInfoName")
  end

  # 将棋盤内で location_key 側のプレイヤー名は user_name になっている
  def assert_sp_player_name(location_key, user_name)
    within(".ShogiPlayer") do
      assert_selector(:element, :class => ["Membership", "is_#{location_key}"], text: user_name, exact_text: true)
    end
  end

  # ▲△の順に指定のプレイヤー名を表示している
  def assert_sp_player_names(black_name, white_name)
    assert_sp_player_name(:black, black_name)
    assert_sp_player_name(:white, white_name)
  end

  # メンバーリストの上からi番目の状態と名前
  # 一気に調べるのではなく段階的に調べる
  def assert_member_list(i, klass, user_name)
    assert_selector(".ShareBoardMemberListOne:nth-child(#{i})")             # まずi番目が存在する
    assert_selector(".ShareBoardMemberListOne:nth-child(#{i}).#{klass}")    # 次にi番目の種類
    # i 番目のメンバーは user_name である
    assert_selector(:xpath, "//*[contains(@class, 'ShareBoardMemberListOne')][#{i}]//*[text()='#{user_name}']")
  end

  # メンバーが存在する
  def assert_member_exist(user_name)
    assert_selector(:xpath, "//*[contains(@class, 'ShareBoardMemberList')]//*[text()='#{user_name}']")
  end

  # メンバーが存在しない
  def assert_member_missing(user_name)
    assert_no_selector(:xpath, "//*[contains(@class, 'ShareBoardMemberList')]//*[text()='#{user_name}']")
  end

  # メンバーリストの上ら i 番目をクリック
  def member_list_click_nth(i)
    assert_selector(".ShareBoardMemberListOne", wait: 60)
    find(".ShareBoardMemberListOne:nth-child(#{i})").click
  end

  # メンバーリストの指定の名前をクリック
  def member_list_name_click(name)
    find(".ShareBoardMemberList .user_name", text: name, exact_text: true).click
  end

  def sp_controller_click(klass)
    find(".ShogiPlayer .NavigateBlock .button.#{klass}").click
  end

  def room_recreate_apply
    hamburger_click
    menu_item_click("再起動")     # モーダルを開く
    apply_button  # 実行する
  end

  def assert_turn(turn)
    assert_text("current_turn:#{turn}", wait: 10)
  end

  # 順番設定後の待ち
  def apply_after_wait
    sleep(2)
  end

  def buefy_dialog_button_click(type = "")
    find(".modal button#{type}").click
  end

  def clock_open
    hamburger_click
    cc_modal_handle             # 「対局時計」モーダルを開く

    assert_clock_off            # 時計はまだ設置されていない
    clock_switch_toggle          # 設置する
    assert_clock_on             # 時計が設置された
  end

  # 退室
  def room_leave
    hamburger_click
    room_setup_modal_handle  # 「部屋に入る」を自分でクリックする
    first(".leave_button").click   # 退室ボタンをクリックする
    first(".close_handle").click   # 閉じる
  end

  # 手合割選択
  def preset_select(preset_key)
    hamburger_click
    menu_item_click("手合割")
    find(".BoardPresetSelectModal .board_preset_key").select(preset_key)
    find(".apply_button").click
  end

  def order_set_on
    order_modal_main_switch_click("ON")
  end

  def order_set_off
    order_modal_main_switch_click("OFF")
  end

  def order_modal_main_switch_click(on_or_off)
    hamburger_click
    os_modal_handle                        # 「順番設定」モーダルを開く
    os_switch_toggle                         # 有効スイッチをクリック (最初なので同時に適用を押したの同じで内容も送信)
    action_log_row_of(0).assert_text("順番 #{on_or_off}")
    modal_close_handle                                  # 閉じる (ヘッダーに置いている)
  end

  def apply_button
    first(".apply_button").click
  end

  def modal_close_handle
    first(".close_handle_for_capybara").click          # 閉じる (ヘッダーに置いている)
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

  def assert_viewpoint(location_key)
    assert_selector(".CustomShogiPlayer .is_viewpoint_#{location_key}")
  end

  def assert_order_setting_members(names)
    result = all(".TeamsContainer tbody .user_name").collect(&:text)
    assert { result == names }
  end

  # なんでもいいから1vs1のルールを選択する
  def xmatch_select_1vs1
    hamburger_click
    menu_item_click("自動マッチング")           # モーダルを開く
    find(".rule_1vs1_05_00_00_5_pRvsB").click   # 飛vs角を選択
  end

  # 時間切れモーダルが存在する
  def assert_time_limit_modal_exist
    assert_selector(".TimeLimitModal")
  end

  # URLにする時計のパラメータ
  def clock_box_params(values)
    [
      :"clock_box_initial_main_min",
      :"clock_box_initial_read_sec",
      :"clock_box_initial_extra_sec",
      :"clock_box_every_plus",
    ].zip(values).to_h
  end

  def assert_var(key, value)
    assert_text "#{key}:#{value}"
  end

  def cc_at(n)
    ".cc_form_block:nth-child(#{n})"
  end

  def cc_form_block_eq(n, values)
    result = Capybara.within(cc_at(n)) { clock_box_values }
    assert { result == values }
  end

  def cc_in(n, &block)
    Capybara.within(cc_at(n), &block)
  end

  def room_setup_modal_handle
    find(".room_setup_modal_handle").click
  end

  def os_modal_handle
    find(".os_modal_handle").click
  end

  def cc_modal_handle
    find(".cc_modal_handle").click
  end

  def assert_system_variable(key, value)
    assert_selector(".assert_system_variable .panel-block", text: "#{key}:#{value}", exact_text: true)
  end

  # 順番設定と対局時計の右上の有効をトグルする
  def os_switch_toggle
    # 本当は find(:checkbox, "有効", exact: true).click と書きたいがなぜか動かない
    find("label", :class => "main_switch", text: "有効", exact_text: true).click
  end

  def clock_switch_toggle
    find("label", :class => "main_switch", text: "設置", exact_text: true).click
  end

  def kifu_yomikomi
    hamburger_click
    menu_item_click("棋譜の読み込み")
    find(".AnySourceReadModal textarea").set("68S", clear: :backspace)
    find(".AnySourceReadModal .submit_handle").click
  end

  def assert_honpu_link_exist
    assert_selector("a", text: "本譜", exact_text: true)
  end

  # 操作履歴
  prepend Module.new {
    # スコープを合わせる
    def action_log_scope(&block)
      within(".ShareBoardActionLog", &block)
    end

    # 完全一致のテキストがあること
    def action_assert_text(text)
      action_log_scope do
        assert_selector("div", text: text, exact_text: true)
      end
    end

    # 履歴の上から index 目の行
    def action_log_row_of(index)
      # action_log_scope do
      find(".ShareBoardActionLog .ShareBoardAvatarLine:nth-child(#{index.next})")
      # end
    end

    # 履歴の index 番目は user が behavior した
    def action_assert(index, user, behavior)
      within(action_log_row_of(index)) do
        assert_selector(:element, text: user,     exact_text: true)
        assert_selector(:element, text: behavior, exact_text: true)
      end
    end
  }
end

RSpec.configure do |config|
  config.include(SharedMethods, type: :system, share_board_spec: true)
end
