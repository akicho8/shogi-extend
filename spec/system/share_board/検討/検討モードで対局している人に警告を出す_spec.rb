require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    room_setup_by_user(user_name, misuse_detector_feature_p: true, MISUSE_DETECTOR_COUNT_MAX: 2)
  end

  it "works" do
    window_a { case1(:a) }
    window_b { case1(:b) }

    window_a { black_king_move_up }
    window_b { white_king_move_up }

    window_a do
      assert_no_selector ".MisuseModal"
      black_king_move_down
      assert_selector ".MisuseModal"
    end

    window_b do
      assert_no_selector ".MisuseModal"
      white_king_move_down
      assert_selector ".MisuseModal"
    end
  end
end
