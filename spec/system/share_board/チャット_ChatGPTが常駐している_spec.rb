require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  before do
    visit_app({
        :user_name            => "a",
        :FIXED_MEMBER   => "a,b,c,d",
        :fixed_order    => "a,b,c,d",
      })
    find(".chat_modal_open_handle").click
  end

  it "@gpt", chat_gpt_spec: true do
    chat_message_send("@gpt こんにちは")
    assert_message_latest_from("GPT", wait: 30)
  end
end
