require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(change_per, order)
    visit_room({
        :change_per   => change_per,
        :user_name    => "a",
        :FIXED_MEMBER => "a,b,c",
        :FIXED_ORDER  => "a,b,c",
        :body         => SfenGenerator.start_from(:white),
      })
    assert_var("本順序", order)
  end

  it { case1(1, "babc")     } # 白からなら白チームから
  it { case1(2, "bababcbc") }
end
