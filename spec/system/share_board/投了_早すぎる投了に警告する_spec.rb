require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(names)
    visit_room({
        :user_name         => :a,
        :FIXED_MEMBER      => names,
        :FIXED_ORDER       => names,
        :room_after_create => :cc_auto_start_10m,
      })
  end

  it "2vs1なので警告が出る" do
    case1 "a,b,c"
    give_up_modal_open_handle
    assert_selector(".give_up_warn_message")
  end

  it "1vs1なので警告が出ない" do
    case1 "a,b"
    give_up_modal_open_handle
    assert_no_selector(".give_up_warn_message")
  end
end
