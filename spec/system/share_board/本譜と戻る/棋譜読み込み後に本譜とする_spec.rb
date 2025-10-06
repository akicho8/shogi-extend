require "#{__dir__}/helper"

RSpec.describe type: :system, share_board_spec: true do
  it "通常" do
    visit_app
    kifu_yomikomi               # 棋譜読み込み後に
    assert_honpu_open_on     # 本譜が出現している
  end

  it "部屋" do
    a_block { visit_room(room_key: :test_room, user_name: "alice") }
    b_block { visit_room(room_key: :test_room, user_name: "bob")   }
    a_block do
      kifu_yomikomi
      assert_honpu_open_on
    end
    b_block do
      assert_honpu_open_on   # alice が棋譜読み込み後に bob の方にも本譜が出現している
    end
  end
end
