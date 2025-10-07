require "#{__dir__}/shared_methods"

# 順番設定を適用する引数で起動したため os_setup 内の sp_viewpoint_set_by_self_location だけで視点が反映される
# order_copy_from_bc 内のテストにはなっていない
RSpec.describe type: :system, share_board_spec: true do
  def case1(fixed_order_state, b_or_w, user_name)
    visit_room({
        :room_key             => :test_room,
        :user_name            => user_name,
        :fixed_member_names   => "a,b",
        :fixed_order_names    => "a,b",
        :fixed_order_state    => fixed_order_state,
        :handle_name_validate => false,
        :body                 => SfenGenerator.start_from(b_or_w)
      })
  end

  def case2(fixed_order_state, b_or_w, a_side_location_key, b_side_location_key)
    a_block { case1(fixed_order_state, b_or_w, "a") }
    b_block { case1(fixed_order_state, b_or_w, "b") }
    a_block { assert_viewpoint(a_side_location_key) }
    b_block { assert_viewpoint(b_side_location_key) }
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
