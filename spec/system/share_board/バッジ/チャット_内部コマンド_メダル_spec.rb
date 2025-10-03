require "#{__dir__}/../shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  # def case1(user_name)
  #   visit_app({
  #       :room_key            => :test_room,
  #       :user_name            => user_name,
  #       :fixed_member_names   => "a,b",
  #       :fixed_order_names    => "a,b",
  #       :handle_name_validate => "false",
  #     })
  # end
  #
  # before do
  #   a_block { case1("a") }
  #   b_block { case1("b") }
  # end

  # it "/xbadge-user" do
  #   a_block do
  #     chat_message_send2("/xbadge-user b +2")
  #     assert_member_has_text("b", "⭐⭐")
  #
  #     chat_message_send2("/xbadge-user b -1")
  #     assert_member_has_text("b", "⭐")
  #   end
  #
  #   b_block do
  #     assert_member_has_text("b", "⭐")
  #   end
  # end
  #
  # it "/xbadge-team" do
  #   a_block do
  #     chat_message_send2("/xbadge-team white +1")
  #     assert_member_has_text("b", "⭐")
  #   end
  #   b_block do
  #     assert_member_has_text("b", "⭐")
  #   end
  # end
  #
  # it "/xbadge-self" do
  #   a_block do
  #     chat_message_send2("/xbadge-self 1")
  #     assert_member_has_text("a", "⭐")
  #   end
  #   b_block do
  #     assert_member_has_text("a", "⭐")
  #   end
  # end

  # it "/xbadge" do
  #   a_block do
  #     chat_modal_open
  #     chat_message_send("/xbadge")
  #     assert_message_received_o('{"a":0,"b":0}') # a は b の個数を受信しているの重要
  #   end
  # end
end
