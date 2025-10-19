require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(button_name)
    visit_room({
        :user_name    => "1",
        :fixed_member => "1,2,3,4,5,6,7,8",
        :fixed_order  => "1,2,3,4,5,6,7,8",
      })

    os_modal_open
    os_switch_toggle
    os_modal_close

    assert_var("仮順序", "12345678")
    os_modal_open
    find(:button, text: button_name, exact_text: true).click
    assert_text("1さんが#{button_name}しました")
    os_modal_close
    os_modal_close_force
    assert_no_var("仮順序", "12345678")
  end

  it "works" do
    case1("全体ｼｬｯﾌﾙ")
    case1("ﾁｰﾑ内ｼｬｯﾌﾙ")
  end
end
