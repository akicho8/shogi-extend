require "#{__dir__}/shared_methods"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  def case1(user_name)
    visit_room({
        :user_name         => user_name,
        :FIXED_MEMBER      => "a,b",
        :FIXED_ORDER       => "a,b",
        :yomiage_mode_key  => :is_yomiage_mode_on,
        :room_after_create => :cc_auto_start_10m,
      })
  end

  # コードを実行するだけのテストになっている
  # しゃべっているかのテストはできない
  it "works" do
    window_a { case1("a") }
    window_b { case1("b") }
    window_a do
      piece_move_o("77", "76", "☗7六歩")
    end
  end
end
