require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  # def case1(user_name)
  #   visit_app({
  #  #       :user_name            => user_name,
  #       :FIXED_MEMBER   => "a,b",
  #       :FIXED_ORDER    => "a,b",
  #     })
  # end
  #
  # before do
  #   window_a { case1("a") }
  #   window_b { case1("b") }
  # end

  # it "/xprofile-user" do
  #   window_a do
  #     chat_message_send2("/xprofile-user b +2")
  #     assert_member_has_text("b", "⭐⭐")
  #
  #     chat_message_send2("/xprofile-user b -1")
  #     assert_member_has_text("b", "⭐")
  #   end
  #
  #   window_b do
  #     assert_member_has_text("b", "⭐")
  #   end
  # end
  #
  # it "/xprofile-team" do
  #   window_a do
  #     chat_message_send2("/xprofile-team white +1")
  #     assert_member_has_text("b", "⭐")
  #   end
  #   window_b do
  #     assert_member_has_text("b", "⭐")
  #   end
  # end
  #
  # it "/xprofile-self" do
  #   window_a do
  #     chat_message_send2("/xprofile-self 1")
  #     assert_member_has_text("a", "⭐")
  #   end
  #   window_b do
  #     assert_member_has_text("a", "⭐")
  #   end
  # end

  # it "/xprofile" do
  #   window_a do
  #     chat_modal_open
  #     chat_message_send("/xprofile")
  #     assert_message_received_o('{"a":0,"b":0}') # a は b の個数を受信しているの重要
  #   end
  # end
end
