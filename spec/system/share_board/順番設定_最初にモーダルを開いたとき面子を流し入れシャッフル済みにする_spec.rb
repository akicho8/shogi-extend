require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(shuffle_first)
    visit_room({
        :user_name     => "a",
        :FIXED_MEMBER  => "a,b,c,d,e,f,g,h",
        :shuffle_first => shuffle_first,
      })
    order_set_on
  end

  it "無効" do
    case1(false)
    assert_var("仮順序", "abcdefgh")
  end

  it "有効(初期値)" do
    case1(true)
    assert_no_var("仮順序", "abcdefgh")
  end
end
