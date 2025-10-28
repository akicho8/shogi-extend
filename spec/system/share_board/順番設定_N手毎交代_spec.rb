require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(FIXED_ORDER_STATE, change_per, order)
    visit_room({
        :change_per           => change_per,
        :user_name            => "a",
        :FIXED_MEMBER   => "a,b,c",
        :FIXED_ORDER    => "a,b,c",
        :FIXED_ORDER_STATE    => FIXED_ORDER_STATE,
        :body                 => SfenGenerator.start_from(:white),
      })
    assert_var("本順序", order)
  end

  it { case1("to_o1_state", 1, "abc")      } # 白からでも順番通り
  it { case1("to_o1_state", 2, "ababca")   }
  it { case1("to_o2_state", 1, "babc")     } # 白からなら白チームから
  it { case1("to_o2_state", 2, "bababcbc") }
end
