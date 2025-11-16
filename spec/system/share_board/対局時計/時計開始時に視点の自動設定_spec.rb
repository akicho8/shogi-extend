# 対局時計のタイミングでは反転しないようにしたのでこのテストはスキップする

require "#{__dir__}/../shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def visit_room(fixed_order_state, b_or_w, user_name)
    visit_app({
        :user_name      => user_name,
        :FIXED_MEMBER   => "a,b",
        :FIXED_ORDER    => "a,b",
        :FIXED_ORDER_STATE    => fixed_order_state,
        :body                 => SfenGenerator.start_from(b_or_w)
      })
  end

  def case1(fixed_order_state, b_or_w, a_side_location_key, b_side_location_key)
    window_a { visit_room(fixed_order_state, b_or_w, "a") }
    window_b { visit_room(fixed_order_state, b_or_w, "b") }
    window_a do
      clock_start # 対局時計PLAY
    end
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
  xit { case1(:to_o1_state, :black, :black, :white) }
  xit { case1(:to_o1_state, :white, :white, :black) }
  xit { case1(:to_o2_state, :black, :black, :white) }
  xit { case1(:to_o2_state, :white, :black, :white) }
end
