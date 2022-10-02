require "rails_helper"
Pathname(__dir__).glob("shared_methods/*.rb") { |e| require(e) }

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
    assert_text(user_name) # 入力したハンドルネームの人が参加している
  end

  def room_setup_by_fillin_params
    hamburger_click
    room_setup_modal_handle                       # 「部屋に入る」を自分でクリックする
    Capybara.within(".RoomSetupModal") do
      find(".entry_button").click                 # 共有ボタンをクリックする
      find(".close_handle").click                 # 閉じる
    end
  end

  def room_recreate_apply
    hamburger_click
    menu_item_click("再起動")     # モーダルを開く
    apply_button  # 実行する
  end

  def buefy_dialog_button_click(type = "")
    find(".modal button#{type}").click
  end

  # 退室
  def room_leave
    hamburger_click
    room_setup_modal_handle        # 「部屋に入る」を自分でクリックする
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

  def assert_var(key, value)
    assert_text "#{key}:#{value}"
  end

  def room_setup_modal_handle
    find(".room_setup_modal_handle").click
  end

  def assert_system_variable(key, value)
    assert_selector(".assert_system_variable .panel-block", text: "#{key}:#{value}", exact_text: true)
  end

  def assert_no_system_variable(key, value)
    assert_no_selector(".assert_system_variable .panel-block", text: "#{key}:#{value}", exact_text: true)
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
end

RSpec.configure do |config|
  config.include(SharedMethods, type: :system, share_board_spec: true)
end
