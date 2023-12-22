require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(ai_auto_response_ratio)
    visit_app({
        :room_key               => :test_room,
        :user_name              => "alice",
        :ai_auto_response_ratio => ai_auto_response_ratio,
        :__system_test_now__    => "",
      })
    chat_modal_open
    chat_message_send("1+2は？")
  end

  it "必ず返答する" do
    case1(1)
    assert_message_latest_from("GPT", wait: 5)
  end

  it "必ず返答しない" do
    case1(0)
    assert_no_message_latest_from("GPT", wait: 5)
  end
end
