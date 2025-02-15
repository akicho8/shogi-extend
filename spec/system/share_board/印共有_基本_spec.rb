require "#{__dir__}/shared_methods"

RSpec.describe "印共有_基本", type: :system, share_board_spec: true do
  it "右上のペンマークをクリックすると有効になる" do
    visit_app(user_name: "alice")
    assert_system_variable("think_mark_mode_p", "false")
    find(".think_mark_toggle_button_click_handle").click
    assert_system_variable("think_mark_mode_p", "true")
  end

  it "クリックした場所に円と名前が出る" do
    visit_app(user_name: "alice", think_mark_mode_p: true)
    place_click("76")
    assert_selector(".place_7_6 .ThinkMark", text: "alice")
  end

  it "同じ場所を二度クリックすると印が消える" do
    visit_app(user_name: "alice", think_mark_mode_p: true)
    place_click("76")
    assert_selector(".place_7_6 .ThinkMark")
    place_click("76")
    assert_no_selector(".place_7_6 .ThinkMark")
  end

  it "複数の箇所に印を出せる" do
    visit_app(user_name: "alice", think_mark_mode_p: true)
    place_click("77")
    place_click("76")
    assert_selector(".place_7_7 .ThinkMark")
    assert_selector(".place_7_6 .ThinkMark")
  end

  # it "main" do
  #   # visit_app({
  #   #     :room_key             => :test_room,
  #   #     :user_name            => "a",
  #   #     :fixed_member_names   => "a,b,c",
  #   #     :fixed_order_names    => "a,b",
  #   #     :handle_name_validate => "false",
  #   #     :fixed_order_state    => "to_o2_state",
  #   #     :think_mark_mode_p    => true,
  #   #   })
  #   # debugger
  # end
end
