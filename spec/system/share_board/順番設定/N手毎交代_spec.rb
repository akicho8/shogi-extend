require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(fixed_order_operation, change_per, order)
    visit_room({
        :change_per           => change_per,
        :user_name            => "a",
        :FIXED_MEMBER   => "a,b,c",
        :FIXED_ORDER    => "a,b,c",
        :FIXED_ORDER_OPERATION    => fixed_order_operation,
        :body                 => SfenGenerator.start_from(:white),
      })
    assert_var("本順序", order)
  end

  it { case1("to_v1_operation", 1, "abc")      } # 白からでも順番通り
  it { case1("to_v1_operation", 2, "ababca")   }
  it { case1("to_v2_operation", 1, "babc")     } # 白からなら白チームから
  it { case1("to_v2_operation", 2, "bababcbc") }
end
