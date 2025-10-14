require "#{__dir__}/helper"

RSpec.describe __FILE__, type: :system, share_board_spec: true do
  it "works" do
    window_a { visit_app(body: Bioshogi::SFEN1) }         # 盤面情報をつけてくると本譜ができる
    window_b { visit_app }
    window_a do
      assert_honpu_open_on                               # 本譜がある
      room_menu_open_and_input(:test_room, :alice)     # 入室
      sleep(1)
    end
    window_b do
      assert_honpu_open_off                              # 本譜が共有されていない
      room_menu_open_and_input(:test_room, :bob)       # 入室
      assert_honpu_open_on                               # 本譜が共有された
    end
  end
end
