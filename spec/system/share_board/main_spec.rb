require "#{__dir__}/shared_methods"

RSpec.describe "共有将棋盤", type: :system, share_board_spec: true do
  # include SharedMethods
  # before do
  #   XmatchRuleInfo.clear_all    # 重要
  # end

  it "works" do
    assert { (1 + 2) == 3 }
  end
end
