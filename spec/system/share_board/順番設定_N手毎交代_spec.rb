require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(fixed_order_state, change_per, order)
    visit_room({
        :change_per           => change_per,
        :user_name            => "a",
        :fixed_member_names   => "a,b,c",
        :fixed_order_names    => "a,b,c",
        :fixed_order_state    => fixed_order_state,
        :body                 => SfenGenerator.start_from(:white),
      })
    assert_var("本順序", order)
  end

  it { case1("to_o1_state", 1, "abc")      } # 白からでも順番通り
  it { case1("to_o1_state", 2, "ababca")   }
  it { case1("to_o2_state", 1, "babc")     } # 白からなら白チームから
  it { case1("to_o2_state", 2, "bababcbc") }
end
