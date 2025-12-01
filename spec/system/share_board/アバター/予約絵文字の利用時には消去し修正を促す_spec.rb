require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_app({
        :user_selected_avatar => "🤖",
        :avatar_hard_validation => true,
      })
    assert_var :user_selected_avatar, "" # 予約アバターだったため強制的に消去している
    assert_avatar_input_modal_exist      # ついてで入力モーダルを起動している
    assert_avatar_input ""               # そこでも入力は空になっている
  end
end
