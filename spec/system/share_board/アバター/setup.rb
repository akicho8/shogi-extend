require "#{__dir__}/../shared_methods"

mod = Module.new do
  def assert_avatar_input_modal_exist
    assert_selector ".AvatarInputModal"
  end

  def assert_avatar_input_modal_none
    assert_no_selector ".AvatarInputModal"
  end

  def avatar_input(str)
    find(".new_user_selected_avatar_input_tag").find(:fillable_field).set(str)
  end

  def assert_avatar_input(str)
    within(".new_user_selected_avatar_input_tag") { assert_selector(:fillable_field, with: str) }
  end

  def assert_avatar_preview(emoji)
    assert_selector(".preview_container img[alt='#{emoji}']")
  end

  def avatar_input_modal_submit_handle
    find(".avatar_input_modal_submit_handle").click
  end

  def avatar_input_modal_close_handle
    find(".avatar_input_modal_close_handle").click
  end

  ################################################################################ 履歴機能

  def avatar_showcase_first_emoji_click
    first(".AvatarInputModal .avatar_showcase a").click
  end

  def assert_exist_in_avatar_showcase(emoji)
    assert_selector(".AvatarInputModal .avatar_showcase img[alt='#{emoji}']", count: 1)
  end

  ################################################################################
end

RSpec.configure do |config|
  config.include(mod, type: :system, share_board_spec: true)
end
