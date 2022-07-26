require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(hand_every_n, order)
    visit_app(hand_every_n: hand_every_n, room_code: :my_room, force_user_name: "a", ordered_member_names: "a,b,c", handle_name_validate_skip: "true")
    assert_text("順序:#{order}")
  end

  it "works" do
    case1(1, "abcabcabcab")
    case1(2, "ababcacabcb")
    case1(3, "abababcacac")
  end
end
