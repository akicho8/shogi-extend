require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "旧パラメータの room_code で入れる" do
    visit_room(room_code: :test_room, user_name: :alice)
    assert_room_created
    assert_member_exist(:alice)
  end

  it "新パラメータの room_key で入れる" do
    visit_room(user_name: :alice)
    assert_member_exist(:alice)
  end
end
