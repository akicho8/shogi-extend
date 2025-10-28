require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a do
      visit_room(user_name: :a) # このテストに限っては FIXED_MEMBER 使用禁止
    end
    window_b do
      visit_room(user_name: :b)
    end
    window_a do
      assert_member_exist(:b)      # b は部屋にいる
      chat_message_send2("/kick b") # b を退出させる
      assert_member_missing(:b)    # b は退出させられた
    end
  end
end
