require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def visit_app2(fixed_order_state, b_or_w, fixed_user_name)
    visit_app({
        :room_code            => :my_room,
        :fixed_user_name      => fixed_user_name,
        :fixed_member_names   => "a,b",
        :fixed_order_names    => "a,b",
        :fixed_order_state    => fixed_order_state,
        :handle_name_validate => false,
        :body                 => SfenGenerator.start_from(b_or_w)
      })
  end

  def case1(fixed_order_state, b_or_w, a_side_location_key, b_side_location_key)
    a_block { visit_app2(fixed_order_state, b_or_w, "a") }
    b_block { visit_app2(fixed_order_state, b_or_w, "b") }
    a_block do
      clock_start # 対局時計PLAY
    end
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
  it { case1(:to_o1_state, :black, :black, :white) }
  it { case1(:to_o1_state, :white, :white, :black) }
  it { case1(:to_o2_state, :black, :black, :white) }
  it { case1(:to_o2_state, :white, :black, :white) }
end
