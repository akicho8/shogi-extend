require "#{__dir__}/shared_methods"

# 順番設定を適用する引数で起動したため os_setup 内の sp_viewpoint_switch_to_self_location だけで視点が反映される
# order_copy_from_bc 内のテストにはなっていない
RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(fixed_order_state, b_or_w, user_name)
    visit_room({
        :user_name            => user_name,
        :FIXED_MEMBER   => "a,b",
        :FIXED_ORDER    => "a,b",
        :FIXED_ORDER_STATE    => fixed_order_state,
        :body                 => SfenGenerator.start_from(b_or_w)
      })
  end

  def case2(fixed_order_state, b_or_w, a_side_location_key, b_side_location_key)
    window_a { case1(fixed_order_state, b_or_w, "a") }
    window_b { case1(fixed_order_state, b_or_w, "b") }
    window_a { assert_viewpoint(a_side_location_key) }
    window_b { assert_viewpoint(b_side_location_key) }
  end

  # |------+------+----+----|
  # | 順番 | 手合 | a  | b  |
  # |------+------+----+----|
  # | 1列  | 平手 | ▲ | △ |
  # |      | 落ち | △ | ▲ |
  # |------+------+----+----|
  # | 2列  | 平手 | ▲ | △ |
  # |      | 落ち | ▲ | △ |
  # |------+------+----+----|
  it { case2(:to_o1_state, :black, :black, :white) }
  it { case2(:to_o1_state, :white, :white, :black) }
  it { case2(:to_o2_state, :black, :black, :white) }
  it { case2(:to_o2_state, :white, :black, :white) }
end
