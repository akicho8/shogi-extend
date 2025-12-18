require "#{__dir__}/sb_support_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "部屋に直行する (デフォルト)" do
    visit_room({
        :user_name => :a,
        :url_room_key_exist_behavior => :room_enter_direct,
      })
  end

  it "部屋に直行する場合でも不正なハンドルネームの場合はモーダルを表示する (デフォルト)" do
    visit_base({
        :room_key => :test_room,
        :user_name => "nanashi",
        :FIXED_ORDER => "nanashi",
        :ng_word_check_p => true,
        :url_room_key_exist_behavior => :room_enter_direct,
      })
    assert_selector(".GateModal")
  end

  it "いったんモーダルを表示する (ハンドルネームを変更しやすい)" do
    visit_app({
        :room_key => :test_room,
        :user_name => :a,
        :url_room_key_exist_behavior => :modal_open,
      })
    assert_selector(".GateModal")
  end
end
