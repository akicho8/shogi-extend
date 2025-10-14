require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  before do
    visit_room({
        :user_name            => "a",
        :fixed_member   => "a,b,c,d",
        :fixed_order    => "a,b,c,d",
        :title                => "(title)",
      })
    chat_modal_open
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

  it "/gpt", chat_gpt_spec: true do
    chat_message_send("/gpt こんにちは")
    assert_message_latest_from("GPT", wait: 30)
  end

  it "/send" do
    chat_message_send("/send func_add a b")
    assert_message_received_o("ab")
  end

  it "/header" do
    chat_message_send("/header")
    assert_message_received_o("棋戦: (title)\n☗側: a,c\n☖側: b,d")
  end

  it "/対局中" do
    chat_message_send("/対局中")
    chat_modal_close
    assert_clock_on
    assert_order_on
  end
end
