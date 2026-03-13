require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    visit_room({
        :user_name    => "a",
        :FIXED_MEMBER => "a,b,c,d,e,f,g,h",
      })
    order_set_on
    assert_var("仮順序", "abcdefgh")
  end
end
