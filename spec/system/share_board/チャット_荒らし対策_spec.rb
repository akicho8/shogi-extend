require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  before do
    visit_app({
        :room_key             => :test_room,
        :user_name            => "a",
        :fixed_member_names   => "a,b",
        :fixed_order_names    => "a,b",
        :handle_name_validate => "false",
        :ARASHI_THRESHOLD     => 1,
        :ARASHI_RE_RATE       => 1,
      })
    find(".chat_modal_open_handle").click
  end

  it "荒らし対策" do
    chat_message_send("a" * 20)
    chat_modal_close
    assert_system_variable(:arashi_count, 1)
  end
end
