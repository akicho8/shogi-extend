require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(button_name)
    visit_room({
        :user_name    => "1",
        :FIXED_MEMBER => "1,2,3,4,5,6,7,8",
        :FIXED_ORDER  => "1,2,3,4,5,6,7,8",
      })

    assert_var("本順序", "12345678")
    os_modal_open
    find(:button, text: button_name, exact_text: true).click
    assert_text("1さんが#{button_name}しました")
    os_submit_button_click
    os_modal_close
    assert_no_var("本順序", "12345678")
  end

  it "works" do
    case1("全体ｼｬｯﾌﾙ")
    case1("ﾁｰﾑ内ｼｬｯﾌﾙ")
  end
end
