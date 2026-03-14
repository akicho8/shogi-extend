require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app(avatar_history_ary: "🐹")    # 履歴の先頭に入れる
    sidebar_open
    find(".avatar_input_modal_open_handle").click
    avatar_showcase_first_emoji_click         # 履歴の先頭を選択したので
    assert_avatar_input "🐹"               # 入力欄が切り替わっている

    avatar_input "❤️"                       # それを書き換えて入力し
    avatar_input_modal_submit_handle       # 確定し
    sidebar_open
    find(".avatar_input_modal_open_handle").click
    assert_exist_in_avatar_showcase "❤️"       # 履歴の先頭にそれが入っている
  end
end
