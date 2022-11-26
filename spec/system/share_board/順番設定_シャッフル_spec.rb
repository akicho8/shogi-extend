require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1
    visit_app({
        :room_code            => :test_room,
        :user_name            => "1",
        :fixed_member_names   => "1,2,3,4,5,6,7,8",
        :fixed_order_names    => "1,2,3,4,5,6,7,8",
        :fixed_order_state    => "to_o2_state",
        :handle_name_validate => "false",
        :autoexec             => "os_modal_handle",
      })
  end

  it "全体シャッフル" do
    case1
    assert_system_variable("仮順序", "12345678")
    find(:button, text: "全体ｼｬｯﾌﾙ", exact_text: true).click
    assert_text("1さんが全体シャッフルしました", wait: 30)
    assert_no_system_variable("仮順序", "12345678")
  end

  it "チーム内シャッフル" do
    case1
    assert_system_variable("仮順序", "12345678")
    find(:button, text: "ﾁｰﾑ内ｼｬｯﾌﾙ", exact_text: true).click
    assert_text("1さんがチーム内シャッフルしました", wait: 30)
    assert_no_system_variable("仮順序", "12345678")
  end
end
