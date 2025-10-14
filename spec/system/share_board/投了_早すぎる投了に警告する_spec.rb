require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(names)
    visit_room({
        :user_name            => :alice,
        :fixed_member   => names,
        :fixed_order    => names,
        :fixed_order_state    => "to_o2_state",
        :room_create_after_action => :cc_auto_start,
      })
  end

  it "2vs1なので警告が出る" do
    case1 "alice,bob,carol"
    give_up_modal_open_handle
    Capybara.assert_selector(".give_up_warn_message")
  end

  it "1vs1なので警告が出ない" do
    case1 "alice,bob"
    give_up_modal_open_handle
    Capybara.assert_no_selector(".give_up_warn_message")
  end
end
