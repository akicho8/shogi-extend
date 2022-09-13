require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    visit_app(room_code: :my_room, fixed_user_name: "nanashi", fixed_order_names: "nanashi")
    assert_text("部屋に入る") # ハンドルネームが不正なのでダイアログが出ている
  end
end
