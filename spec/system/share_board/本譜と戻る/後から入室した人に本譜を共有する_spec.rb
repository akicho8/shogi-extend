require "#{__dir__}/helper"

RSpec.describe "後から入室した人に本譜を共有する", type: :system, share_board_spec: true do
  it "works" do
    a_block { visit_app(body: Bioshogi::SFEN1) }         # 盤面情報をつけてくると本譜ができる
    b_block { visit_app }
    a_block do
      assert_honpu_open_on                               # 本譜がある
      room_menu_open_and_input("test_room", "alice")     # 入室
      sleep(1)
    end
    b_block do
      assert_honpu_open_off                              # 本譜が共有されていない
      room_menu_open_and_input("test_room", "bob")       # 入室
      assert_honpu_open_on                               # 本譜が共有された
    end
  end
end
