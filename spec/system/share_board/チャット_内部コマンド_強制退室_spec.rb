require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  it "works" do
    a_block do
      visit_app(room_code: "test_room", user_name: "alice") # このテストに限っては fixed_member_names 使用禁止
    end
    b_block do
      visit_app(room_code: "test_room", user_name: "bob")
    end
    a_block do
      find(".message_modal_handle").click
      assert_member_exist("bob")     # bob は部屋にいる
      chat_message_send("/kill bob") # bob を退出させる
      assert_member_missing("bob")   # bob は退出させられた
    end
  end
end
