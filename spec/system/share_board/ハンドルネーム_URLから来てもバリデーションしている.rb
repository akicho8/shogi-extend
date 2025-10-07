require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_room(room_key: :test_room, user_name: "nanashi", fixed_order_names: "nanashi")
    assert_text("入退室") # ハンドルネームが不正なのでダイアログが出ている
  end
end
