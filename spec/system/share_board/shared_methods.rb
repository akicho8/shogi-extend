require "rails_helper"
Pathname(__dir__).glob("shared_methods/*.rb") { |e| require(e) }

module SharedMethods
  extend ActiveSupport::Concern

  included do
    include AliceBobCarol
  end

  def visit_app(params = {})
    visit_to("/share-board", params)

    params = params.to_options
    if !params[:__visit_app_warning_skip__]
      if params[:room_key] && params[:user_name]
        warn "room_key と user_name がある場合は visit_room を使うこと"
        puts caller.first
      end
    end
  end

  def visit_room(params = {})
    visit_to("/share-board", params)

    if true
      params = params.to_options
      if params[:autoexec_room_create_after] == "os_modal_open_handle"
        warn "assert_room_created が必ず失敗するので autoexec_room_create_after=os_modal_open_handle は使えない"
        puts caller.first
      end
    end

    assert_room_created
  end

  def room_setup(room_key, user_name, params = {})
    params = {
      shuffle_first: false,     # テストにランダム要素が含まれると混乱するため初期値では入室順に順序が決まるようにする
    }.merge(params)
    visit_app(params)
    room_menu_open_and_input(room_key, user_name)
  end

  def room_menu_open_and_input(room_key, user_name)
    global_menu_open
    rsm_open_handle                  # 「入退室」を自分でクリックする
    Capybara.within(".RoomSetupModal") do
      find(".new_room_key input").set(room_key)   # 合言葉を入力する
      find(".new_user_name input").set(user_name) # ハンドルネームを入力する
      find(".room_entry_button").click                 # 共有ボタンをクリックする
      find(".close_handle").click                 # 閉じる
    end
    assert_text(user_name) # 入力したハンドルネームの人が参加している
    assert_room_created
  end

  # 【注意】
  # このチェック対象は地上にあるため os_modal_open_handle などを呼んでモーダルが出ていると読み取れない
  # つまり visit_room で autoexec_room_create_after=os_modal_open_handle などとすると絶対にエラーになってしまう
  def assert_room_created
    assert_var("ac_room", "true", wait: 2)
  end

  def room_setup_by_fillin_params
    global_menu_open
    rsm_open_handle                  # 「入退室」を自分でクリックする
    Capybara.within(".RoomSetupModal") do
      find(".room_entry_button").click            # 共有ボタンをクリックする
      find(".close_handle").click                 # 閉じる
    end
    assert_room_created
  end

  def room_recreate_apply
    global_menu_open
    menu_item_click("再起動")     # モーダルを開く
    apply_button  # 実行する
  end

  def buefy_dialog_button_click(type = "")
    find(".modal button#{type}").click
  end

  # 退室
  def room_leave
    global_menu_open
    rsm_open_handle        # 「入退室」を自分でクリックする
    first(".room_leave_button").click   # 退室ボタンをクリックする
    first(".close_handle").click   # 閉じる
  end

  # 手合割選択
  def preset_select(preset_key)
    global_menu_open
    menu_item_click("手合割")
    find(".PresetSelectModal .board_preset_key").select(preset_key)
    find(".apply_button").click
  end

  # なんでもいいから1vs1のルールを選択する
  def xmatch_select_1vs1
    global_menu_open
    menu_item_click("自動マッチング")           # モーダルを開く
    find(".rule_1vs1_05_00_00_5_pRvsB").click   # 飛vs角を選択
  end

  def xmatch_modal_close
    find(".XmatchModal .close_handle").click
  end

  # 時間切れモーダルが存在する
  def assert_timeout_modal_exist
    assert_selector(".TimeoutModal")
  end

  def cc_timeout_modal_close
    find(".TimeoutModal .close_handle").click
  end

  # def assert_var(key, value)
  #   assert_text "#{key}:#{value}"
  # end

  def rsm_open_handle
    find(".rsm_open_handle").click
  end

  def assert_var(key, value, **options)
    assert_selector(".assert_var .panel-block", text: "#{key}:#{value}", exact_text: true, **options)
  end

  def assert_no_var(key, value, **options)
    assert_no_selector(".assert_var .panel-block", text: "#{key}:#{value}", exact_text: true, **options)
  end

  def kifu_yomikomi
    global_menu_open
    menu_item_click("棋譜の入力")
    find(".AnySourceReadModal textarea").set("68S", clear: :backspace)
    find(".AnySourceReadModal .submit_handle").click
  end
end

RSpec.configure do |config|
  config.include(SharedMethods, type: :system, share_board_spec: true)
end
