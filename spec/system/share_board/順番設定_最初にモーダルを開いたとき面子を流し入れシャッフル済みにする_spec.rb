require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(shuffle_first)
    visit_room({
        :user_name            => "1",
        :fixed_member   => "1,2,3,4,5,6,7,8",
        :fixed_order_state    => "to_o2_state",
        :shuffle_first        => shuffle_first,
      })
    order_set_on
  end

  it "無効" do
    case1(false)
    assert_var("仮順序", "12345678")
  end

  it "有効(初期値)" do
    case1(true)
    assert_no_var("仮順序", "12345678")
  end
end
