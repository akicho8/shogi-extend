require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(ai_auto_response_ratio)
    visit_room({
        :user_name               => :a,
        :ai_auto_response_ratio  => ai_auto_response_ratio,
        :__SYSTEM_TEST_RUNNING__ => "",
      })
    chat_modal_open
    chat_message_send("1+2は？")
  end

  it "必ず返答する", ai_active: true do
    case1(1)
    assert_message_latest_from("GPT", wait: 5)
  end

  it "必ず返答しない" do
    case1(0)
    assert_no_message_latest_from("GPT", wait: 5)
  end
end
