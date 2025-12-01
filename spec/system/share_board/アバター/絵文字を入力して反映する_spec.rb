require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name => "a",
        :autoexec  => "order_self_only_auto_setup,avatar_input_modal_open_handle",
      })

    assert_var :user_selected_avatar, ""
    assert_var :all_user_selected_avatars, ""

    assert_avatar_input_modal_exist
    assert_avatar_input ""
    avatar_input "1️⃣"

    assert_avatar_preview_url "https://cdn.jsdelivr.net/gh/jdecked/twemoji@latest/assets/svg/31-20e3.svg"
    avatar_input_modal_submit_handle

    assert_var :user_selected_avatar, "1️⃣"
    assert_var :all_user_selected_avatars, "1️⃣" # 即時変更ブロードキャストしたことで切り替わっている
  end
end
