require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  before do
    visit_app({
        :room_code            => :test_room,
        :user_name            => "a",
        :fixed_member_names   => "a,b,c,d",
        :fixed_order_names    => "a,b,c,d",
        :handle_name_validate => "false",
      })
    find(".chat_modal_open_handle").click
  end

  it "@gpt" do
    chat_message_send("@gpt こんにちは")
    assert_message_latest_from("GPT", wait: 30)
  end
end
