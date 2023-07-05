require "#{__dir__}/shared_methods"

RSpec.describe type: :system, share_board_spec: true do
  def case1(user_name)
    visit_app({
        :room_code            => :test_room,
        :user_name            => user_name,
        :fixed_member_names   => "a,b,c",
        :fixed_order_names    => "a,b,c",
        :fixed_order_state    => "to_o2_state", # [[a,c], [b]] のチーム分けになる
        :handle_name_validate => "false",
        :change_per               => 2,
      })
  end

  it "works" do
    a_block do
      case1("a")
    end
    b_block do
      case1("b")
    end
    a_block do
      piece_move_o("59", "58", "☗5八玉")
      assert_system_variable(:next_turn_message, "次は、bさんの手番です")
    end
    b_block do
      piece_move_o("51", "52", "☖5二玉")
      assert_system_variable(:next_turn_message, "次も、aさんの手番です")
    end
    a_block do
      piece_move_o("58", "59", "☗5九玉")
      assert_system_variable(:next_turn_message, "次は、bさんの手番です")
    end
    b_block do
      piece_move_o("52", "51", "☖5一玉")
      assert_system_variable(:next_turn_message, "次は、cさんの手番です")
    end
  end
end
