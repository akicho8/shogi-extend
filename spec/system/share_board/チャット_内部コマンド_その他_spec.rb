require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  before do
    visit_app({
        :room_code            => :test_room,
        :fixed_user_name      => "a",
        :fixed_member_names   => "a,b,c,d",
        :fixed_order_names    => "a,b,c,d",
        :handle_name_validate => "false",
      })
    find(".message_modal_handle").click
  end

  it "/ping" do
    chat_message_send("/ping")
    assert_message_received_o("pong")
  end

  it "/test" do
    chat_message_send("/test a b c")
    assert_message_received_o("[ 'a', 'b', 'c' ]")
  end

  it "/echo" do
    chat_message_send("/echo abc")
    assert_message_received_o("abc")
  end

  it "/help" do
    chat_message_send("/help")
    assert_message_received_o("/help", exact_text: false)
  end

  it "/var" do
    chat_message_send("/var user_name")
    assert_message_received_o("a")
  end

  it "/debug" do
    chat_message_send("/debug")
    chat_message_send("/var debug_mode_p")
    assert_message_received_o("false")
    chat_message_send("/debug")
  end

  it "/send" do
    chat_message_send("/send func_add a b")
    assert_message_received_o("ab")
  end

  it "/header" do
    chat_message_send("/header")
    assert_message_received_o("棋戦: 共有将棋盤\n☗側: a, c\n☖側: b, d")
  end

  it "/対局中" do
    chat_message_send("/対局中")
    assert_clock_on
    assert_order_on
  end
end
