require "#{__dir__}/../sb_support_methods"

mod = Module.new do
  # 「投了」を押してモーダルを表示する
  def resign_confirm_modal_open_handle
    find("a", text: "投了", exact_text: true).click
    assert_resign_confirm_modal
  end

  def resign_run
    resign_confirm_modal_open_handle
    find(:button, "投了する").click # モーダルが表示されるので本当に投了する
  end

  # 投了ボタンがある
  def assert_resign_button
    assert_selector("a", text: "投了", exact_text: true)
  end

  # 投了モーダルがある
  def assert_resign_confirm_modal
    assert_selector(".ResignConfirmModal")
  end

  # 投了モーダルがない
  def assert_no_resign_confirm_modal
    assert_no_selector(".ResignConfirmModal")
  end
end

RSpec.configure do |config|
  config.include(mod, type: :system, share_board_spec: true)
end
