require "#{__dir__}/setup"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name        => user_name,
        :FIXED_MEMBER     => "a,b,c",
        :FIXED_ORDER      => "a,b,c",
        :change_per       => 2,
        :yomiage_mode_key => :is_yomiage_mode_off, # 音声再生の終了に影響するため読み上げをOFFにしておく
        :room_after_create => :cc_auto_start_10m,
      })
  end

  it "works" do
    window_a { case1("a") }
    window_b { case1("b") }
    window_a do
      piece_move_o("59", "58", "☗5八玉")
      assert_var(:next_turn_message, "次は、bさんの手番です")
    end
    window_b do
      piece_move_o("51", "52", "☖5二玉")
      assert_var(:next_turn_message, "次も、aさんの手番です")
    end
    window_a do
      piece_move_o("58", "59", "☗5九玉")
      assert_var(:next_turn_message, "次は、bさんの手番です")
    end
    window_b do
      piece_move_o("52", "51", "☖5一玉")
      assert_var(:next_turn_message, "次は、cさんの手番です")
    end
  end
end
