require "#{__dir__}/helper"

RSpec.describe type: :system, share_board_spec: true do
  it "通常" do
    visit_app
    kifu_read_run               # 棋譜読み込み後に
    assert_honpu_open_on     # 本譜が出現している
  end

  it "部屋" do
    window_a { visit_room(user_name: :alice) }
    window_b { visit_room(user_name: :bob)   }
    window_a do
      kifu_read_run
      assert_honpu_open_on
    end
    window_b do
      assert_honpu_open_on   # alice が棋譜読み込み後に bob の方にも本譜が出現している
    end
  end
end
