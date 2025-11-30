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

  def assert_avatar_preview_url(url)
    assert_selector(".preview_container img") { |e| e[:src] == url }
  end

  def avatar_input_modal_submit_handle
    find(".avatar_input_modal_submit_handle").click
  end

  def avatar_input_modal_close_handle
    find(".avatar_input_modal_close_handle").click
  end
end

RSpec.configure do |config|
  config.include(mod, type: :system, share_board_spec: true)
end
